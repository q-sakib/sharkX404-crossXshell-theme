function art--make-factory {
    param(
        [string]$model
    )

    if (-not $model) {
        Write-Host "Usage: make-factory <ModelName>" -ForegroundColor Yellow
        return
    }

    php artisan make:factory "${model}Factory" --model=$model
    Write-Host "✅ Factory for $model created successfully" -ForegroundColor Green
}
