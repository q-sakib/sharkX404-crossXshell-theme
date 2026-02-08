# Save this in your PowerShell profile ($PROFILE)
# Example: notepad $PROFILE
# Then paste this function and save

function DevChecklist-Node {
    param (
        [switch]$Full   # Show full details if needed
    )

    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "                 NODE / NPM CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    # ----------------- General / Version -----------------
    Write-Host "`n[General / Version]" -ForegroundColor Yellow
    Write-Host @"
node -v                        # Show Node.js version
node --version
npm -v                         # Show NPM version
npm --version
"@

    # ----------------- Initialize / Setup -----------------
    Write-Host "`n[Project Initialization / Setup]" -ForegroundColor Yellow
    Write-Host @"
npm init                        # Initialize new project (interactive)
npm init -y                     # Initialize new project (default)
npm install                      # Install dependencies from package.json
npm install <package>            # Install single package locally
npm install -g <package>         # Install globally
npm uninstall <package>          # Remove package
npm update                       # Update packages
"@

    # ----------------- Scripts -----------------
    Write-Host "`n[Scripts]" -ForegroundColor Yellow
    Write-Host @"
npm start                        # Run start script
npm run build                     # Run build script
npm run test                      # Run test script
npm run <script>                  # Run custom script
npx <tool>                        # Run CLI tool without installing globally
"@

    # ----------------- Package Info -----------------
    Write-Host "`n[Package Info / Management]" -ForegroundColor Yellow
    Write-Host @"
npm list                          # List installed packages
npm list -g                       # List global packages
npm outdated                       # Show outdated packages
npm info <package>                 # Show package info
npm init <package>                 # Initialize package
"@

    # ----------------- Cache / Clean -----------------
    Write-Host "`n[Cache / Clean]" -ForegroundColor Yellow
    Write-Host @"
npm cache verify                   # Verify cache
npm cache clean --force            # Clear cache
"@

    # ----------------- Optional Full Details -----------------
    if ($Full) {
        Write-Host "`n[Extras / Advanced]" -ForegroundColor Yellow
        Write-Host @"
npm config list                     # Show npm config
npm config set <key> <value>        # Set npm config
npm config get <key>                # Get config value
npm audit                           # Check for vulnerabilities
npm audit fix                       # Fix vulnerabilities
npm rebuild                         # Rebuild packages
npm ci                              # Install packages exactly from package-lock.json
"@
    }

    Write-Host "`n=============================================" -ForegroundColor Cyan
    Write-Host "                 END OF NODE / NPM CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
}
