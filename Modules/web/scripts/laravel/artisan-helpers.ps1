# 🧱 Laravel Artisan Migration & Schema Helpers

function art--migrate {
    php artisan migrate
}

function art--migrate-fresh {
    php artisan migrate:fresh
}

function art--migrate-refresh {
    php artisan migrate:refresh
}

function art--migrate-reset {
    php artisan migrate:reset
}

function art--migrate-status {
    php artisan migrate:status
}

function art--make-migration {
    param(
        [string]$name,
        [string]$table
    )

    $cmd = "php artisan make:migration $name"

    if ($table) {
        $cmd += " --table=$table"
    }

    Invoke-Expression $cmd
}
