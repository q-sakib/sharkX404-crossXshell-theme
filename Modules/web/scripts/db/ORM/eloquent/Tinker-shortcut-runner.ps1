function tinker--query-builder {
    param(
        [string]$query
    )

    if (-not $query) {
        Write-Host "Usage: query-builder '<Model>::where(...)->get();'" -ForegroundColor Yellow
        return
    }

    php artisan tinker --execute "$query"
}
