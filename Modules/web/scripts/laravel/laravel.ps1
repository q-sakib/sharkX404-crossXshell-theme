# 🚀 Laravel new project
function laravelnew {
    param([string]$name)
    if (-not $name) {
        Write-Host "Usage: laravelnew <project-name>"
        return
    }
    laravel new $name
}

# 🧩 Laravel Artisan shortcuts
function art { param($cmd); php artisan $cmd }

# 🛠 Generate Laravel model
function art-make-model {
    param([string]$name)
    php artisan make:model $name
}

# 🔧 Generate model + migration + controller + factory + seeder
function art-make-model-full {
    param([string]$name)
    php artisan make:model $name -mcrsf
}

# 🧱 Generate migration
function art-make-migration {
    param([string]$name)
    php artisan make:migration $name
}

# 🔁 Run migrations
function art-migrate {
    php artisan migrate
}

# 🔁 Rollback migrations
function art-migrate-rollback {
    php artisan migrate:rollback
}

# 🧪 Laravel seeder
function art-make-seeder {
    param([string]$name)
    php artisan make:seeder $name
}

# 🌱 Run all seeders
function art-dbseed {
    php artisan db:seed
}

# 👮 Create a controller
function art-make-controller {
    param([string]$name)
    php artisan make:controller $name
}

# 🗃️ Create a resource
function art-make-resource {
    param([string]$name)
    php artisan make:resource $name
}

# 🗃️ Create a full API resource
function art-make--f-a-api {
    param([string]$name)
    php artisan make:model $name -a --api
}

# 🔐 Create a middleware
function art-make-middleware {
    param([string]$name)
    php artisan make:middleware $name
}

# 📄 Create a view blade file
function art-make-view {
    param([string]$name)
    New-Item -ItemType File -Path "resources\views\$name.blade.php" -Force | Out-Null
    Write-Host "Created view: resources\views\$name.blade.php"
}

# 🎯 Laravel serve shortcut
function art-serve {
    php artisan serve
}
# 🧹 Clear Laravel caches
function art-clear-cache {
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
} 