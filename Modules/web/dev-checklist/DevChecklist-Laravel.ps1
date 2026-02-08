# Save this in your PowerShell profile ($PROFILE) to use anytime
# Example: notepad $PROFILE
# Then paste this function and save it

function DevChecklist-Laravel {
    param (
        [switch]$Full   # Show full details if needed
    )

    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "           LARAVEL / PHP ARTISAN CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    # ----------------- General / Help -----------------
    Write-Host "`n[General / Help]" -ForegroundColor Yellow
    Write-Host @"
php artisan                 # Show Artisan commands
php artisan list
php artisan help
php artisan help <command>
php artisan --version
"@

    # ----------------- Server / Environment -----------------
    Write-Host "`n[Server / Environment]" -ForegroundColor Yellow
    Write-Host @"
php artisan serve           # Start development server
php artisan down            # Put app in maintenance mode
php artisan up              # Bring app back online
php artisan env             # Show current environment
php artisan key:generate    # Generate app key
php artisan optimize        # Optimize performance
php artisan optimize:clear  # Clear optimization cache
php artisan storage:link    # Create symbolic link to storage
"@

    # ----------------- Cache / Config / View -----------------
    Write-Host "`n[Cache / Config / View]" -ForegroundColor Yellow
    Write-Host @"
php artisan cache:clear
php artisan cache:forget <key>
php artisan config:clear
php artisan config:cache
php artisan view:clear
php artisan view:cache
php artisan route:clear
php artisan route:cache
php artisan route:list
"@

    # ----------------- Database / Migrations -----------------
    Write-Host "`n[Database / Migrations]" -ForegroundColor Yellow
    Write-Host @"
php artisan migrate
php artisan migrate:rollback
php artisan migrate:reset
php artisan migrate:refresh
php artisan migrate:status
php artisan db:seed
php artisan db:wipe
"@

    # ----------------- Make / Generate -----------------
    Write-Host "`n[Make / Generate]" -ForegroundColor Yellow
    Write-Host @"
php artisan make:controller MyController
php artisan make:model MyModel
php artisan make:migration create_table
php artisan make:seeder MySeeder
php artisan make:factory MyFactory
php artisan make:request MyRequest
php artisan make:middleware MyMiddleware
php artisan make:policy MyPolicy
php artisan make:resource MyResource
php artisan make:command MyCommand
"@

    # ----------------- Queue / Jobs -----------------
    Write-Host "`n[Queue / Jobs]" -ForegroundColor Yellow
    Write-Host @"
php artisan queue:work
php artisan queue:listen
php artisan queue:restart
php artisan queue:retry
php artisan queue:failed
php artisan queue:failed:table
"@

    # ----------------- Optional Full Details -----------------
    if ($Full) {
        Write-Host "`n[Extras / Advanced]" -ForegroundColor Yellow
        Write-Host @"
php artisan event:list
php artisan event:generate
php artisan model:prune
php artisan stub:publish
php artisan inspire
"@
    }

    Write-Host "`n=============================================" -ForegroundColor Cyan
    Write-Host "              END OF LARAVEL CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
}
