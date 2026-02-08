# Save this in your PowerShell profile ($PROFILE)
# Example: notepad $PROFILE
# Then paste this function and save it

function DevChecklist-Angular {
    param (
        [switch]$Full   # Show full details if needed
    )

    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "              ANGULAR CLI CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    # ----------------- General / Help -----------------
    Write-Host "`n[General / Help]" -ForegroundColor Yellow
    Write-Host @"
ng                         # Show Angular CLI commands
ng help
ng help <command>
ng version
ng v
"@

    # ----------------- Project Setup -----------------
    Write-Host "`n[Project Setup]" -ForegroundColor Yellow
    Write-Host @"
ng new MyProject
ng new MyProject --routing
ng new MyProject --style=scss
ng new MyProject --standalone
ng add <package>
"@

    # ----------------- Development Server -----------------
    Write-Host "`n[Development Server]" -ForegroundColor Yellow
    Write-Host @"
ng serve
ng serve --open
ng serve --port 4300
ng serve --host 0.0.0.0
ng serve --configuration=production
"@

    # ----------------- Build / Production -----------------
    Write-Host "`n[Build / Production]" -ForegroundColor Yellow
    Write-Host @"
ng build
ng build --configuration=production
ng build --watch
ng build --stats-json
"@

    # ----------------- Testing -----------------
    Write-Host "`n[Testing]" -ForegroundColor Yellow
    Write-Host @"
ng test
ng test --watch
ng test --browsers=ChromeHeadless
ng e2e
"@

    # ----------------- Generate / Scaffolding -----------------
    Write-Host "`n[Generate / Scaffolding]" -ForegroundColor Yellow
    Write-Host @"
ng generate component MyComponent   # component
ng g c MyComponent                  # shorthand
ng generate service MyService       # service
ng g s MyService                    # shorthand
ng generate module MyModule         # module
ng g m MyModule                     # shorthand
ng generate directive MyDirective   # directive
ng g d MyDirective                  # shorthand
ng generate pipe MyPipe             # pipe
ng g p MyPipe                       # shorthand
ng generate guard MyGuard           # guard
ng g g MyGuard                      # shorthand
ng generate interface MyInterface   # interface
ng g i MyInterface                  # shorthand
ng generate enum MyEnum             # enum
ng g e MyEnum                       # shorthand
ng generate class MyClass           # class
ng g cl MyClass                     # shorthand
ng generate resolver MyResolver     # resolver
ng g r MyResolver                   # shorthand
ng generate interceptor MyInterceptor
ng g interceptor MyInterceptor
"@

    # ----------------- Optional Full Details -----------------
    if ($Full) {
        Write-Host "`n[Extras / Advanced]" -ForegroundColor Yellow
        Write-Host @"
ng config
ng config <key> <value>
ng analytics
ng analytics on
ng analytics off
ng extract-i18n
ng doc <keyword>
ng cache
ng cache clean
"@
    }

    Write-Host "`n=============================================" -ForegroundColor Cyan
    Write-Host "               END OF ANGULAR CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
}
