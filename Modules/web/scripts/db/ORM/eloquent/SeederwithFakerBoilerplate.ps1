function art--make-faker-seeder {
    param(
        [string]$model,
        [int]$count = 10
    )

    if (-not $model) {
        Write-Host "Usage: make-faker-seeder <ModelName> [-count 20]" -ForegroundColor Yellow
        return
    }

    $seederName = "${model}Seeder"
    php artisan make:seeder $seederName

    $filePath = "database\seeders\$seederName.php"
    if (-not (Test-Path $filePath)) {
        Write-Warning "Seeder file not found: $filePath"
        return
    }

    $insertCode = @"
use App\Models\\$model;
use Faker\\Factory as Faker;

/**
 * Run the database seeds.
 */
public function run(): void
{
    \$faker = Faker::create();

    for (\$i = 0; \$i < $count; \$i++) {
        $model::create([
            // Example:
            // 'name' => \$faker->name,
        ]);
    }
}
"@

    (Get-Content $filePath) -replace 'public function run\(\): void\s*\{[^}]*\}', $insertCode | Set-Content $filePath

    Write-Host "✅ $seederName.php updated with Faker boilerplate" -ForegroundColor Green
}
