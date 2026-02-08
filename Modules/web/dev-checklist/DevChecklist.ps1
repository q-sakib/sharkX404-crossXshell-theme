# Save this in your PowerShell profile to use anytime
# e.g., $PROFILE -> notepad $PROFILE
# Add this function

function DevChecklist {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "         DEVELOPER CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    Write-Host "`n[LARAVEL / PHP Artisan]" -ForegroundColor Yellow
    Write-Host @"
php artisan serve             # Start dev server
php artisan migrate           # Run migrations
php artisan migrate:rollback  # Rollback last migration
php artisan make:controller MyController
php artisan make:model MyModel
php artisan make:migration create_table
php artisan db:seed
php artisan route:list
php artisan config:clear
php artisan cache:clear
"@

    Write-Host "`n[ANGULAR CLI]" -ForegroundColor Yellow
    Write-Host @"
ng serve                     # Start dev server
ng build                     # Build project
ng test                      # Run unit tests
ng g c MyComponent           # Generate component
ng g s MyService             # Generate service
ng g m MyModule              # Generate module
ng g d MyDirective           # Generate directive
ng g p MyPipe                # Generate pipe
"@

    Write-Host "`n[GIT]" -ForegroundColor Yellow
    Write-Host @"
git status
git add .
git commit -m 'message'
git log --oneline --graph
git branch
git checkout my-branch
git switch my-branch
git merge other-branch
git pull origin main
git push origin main
git stash
git tag v1.0.0
"@

    Write-Host "`n[DATABASE / SQL CHECKS]" -ForegroundColor Yellow
    Write-Host @"
# MySQL / MariaDB / Postgres examples
mysql -u root -p
\c mydatabase                # Switch DB (Postgres)
SHOW DATABASES;
USE mydatabase;
SHOW TABLES;
DESCRIBE mytable;            # Show table structure (MySQL)
\d mytable                   # Show table structure (Postgres)
SELECT * FROM mytable LIMIT 10;
"@

    Write-Host "`n[POWERSHELL HELPFUL SHORTCUTS]" -ForegroundColor Yellow
    Write-Host @"
Clear-Host       # Clear screen
Get-ChildItem    # List files/folders
Get-Content file.txt   # Show file contents
Set-Location path      # Change directory
code .                 # Open current folder in VS Code
"@

    Write-Host "`nDevChecklist-Angular DevChecklist-Angular -Full" -ForegroundColor Cyan
    Write-Host "`nDevChecklist-Database DevChecklist-Database -Full" -ForegroundColor Cyan
    Write-Host "`nDevChecklist-Git DevChecklist-Git -Full" -ForegroundColor Cyan
    Write-Host "`nDevChecklist-Laravel DevChecklist-Laravel -Full" -ForegroundColor Cyan
    Write-Host "`nDevChecklist-Node DevChecklist-Node -Full" -ForegroundColor Cyan
    Write-Host "`nDevChecklist-PowerShell DevChecklist-PowerShell -Full" -ForegroundColor Cyan
    Write-Host "`n===============================================" -ForegroundColor Cyan
    Write-Host "`n===============================================" -ForegroundColor Cyan
    Write-Host "`n===============================================" -ForegroundColor Cyan
    Write-Host "              END OF CHEAT SHEET"                  -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Cyan
}
