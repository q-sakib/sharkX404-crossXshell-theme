function art--register-seeder {
    param([string]$seeder)

    $dbSeederPath = "database\seeders\DatabaseSeeder.php"
    if (-not (Test-Path $dbSeederPath)) {
        Write-Warning "❌ DatabaseSeeder.php not found"
        return
    }

    $lines = Get-Content $dbSeederPath
    $callLine = "        \$this->call([$seeder::class]);"

    if ($lines -match [regex]::Escape($callLine)) {
        Write-Host "ℹ️  Seeder already registered: $seeder" -ForegroundColor Yellow
        return
    }

    $newLines = @()
    $inserted = $false
    foreach ($line in $lines) {
        $newLines += $line
        if ($line -match 'public function run\(\).*{') {
            $newLines += $callLine
            $inserted = $true
        }
    }

    if ($inserted) {
        $newLines | Set-Content $dbSeederPath
        Write-Host "✅ Registered $seeder in DatabaseSeeder.php"
    } else {
        Write-Warning "⚠️ Could not find function run() to inject into"
    }
}
