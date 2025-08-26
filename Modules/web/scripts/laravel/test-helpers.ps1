# 🧪 Laravel Test Helpers

function art--make-test {
    param(
        [string]$name,
        [ValidateSet("unit", "feature")]
        [string]$type = "feature"
    )

    $flag = if ($type -eq "unit") { "--unit" } else { "" }
    php artisan make:test $name $flag
}

function art--run-tests {
    php artisan test
}

function art--test-filter {
    param([string]$name)

    if (-not $name) {
        Write-Host "Usage: test-filter <TestMethodName>" -ForegroundColor Yellow
        return
    }

    php artisan test --filter $name
}
function art--test-watch {
    php artisan test --watch
}