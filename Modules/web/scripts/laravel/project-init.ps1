# 🌀 Git-based Laravel Project Initializer

function gc--init-laravel-project {
    param(
        [string]$repoUrl,
        [string]$dir = "laravel-app"
    )

    git clone $repoUrl $dir
    Set-Location $dir

    Write-Host "🔧 Installing dependencies..."
    composer install

    if (-not (Test-Path ".env")) {
        Copy-Item ".env.example" ".env"
    }

    php artisan key:generate

    if (Test-Path "vendor/bin/sail") {
        Write-Host "⛵ Laravel Sail detected. Starting containers..."
        ./vendor/bin/sail up -d
    }

    Write-Host "📦 Running migrations and seeds..."
    php artisan migrate --seed

    Write-Host "`n✅ Laravel project initialized and ready!" -ForegroundColor Cyan
}
