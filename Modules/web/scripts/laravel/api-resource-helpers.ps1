# 🌐 API Resource Generator Helpers

function art--make-api-resource {
    param(
        [string]$name
    )

    php artisan make:resource $name
}

function art--make-api-controller {
    param(
        [string]$name
    )

    php artisan make:controller "$name" --api
}

function art--make-api {
    param(
        [string]$model
    )

    if (-not $model) {
        Write-Host "Usage: make-api <ModelName>" -ForegroundColor Yellow
        return
    }

    make-model -name $model -migration -controller
    make-api-controller "$model"Controller
    make-api-resource "$model"Resource
}
