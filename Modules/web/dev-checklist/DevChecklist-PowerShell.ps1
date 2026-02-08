# Save this in your PowerShell profile ($PROFILE)
# Example: notepad $PROFILE
# Then paste this function and save

function DevChecklist-PowerShell {
    param (
        [switch]$Full   # Show full details if needed
    )

    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "             POWERSHELL UTILITIES" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    # ----------------- Navigation -----------------
    Write-Host "`n[Navigation]" -ForegroundColor Yellow
    Write-Host @"
Get-Location                  # Show current directory
Set-Location <path>           # Change directory (cd)
Push-Location                 # Push current directory to stack
Pop-Location                  # Pop directory from stack
Get-ChildItem                 # List files/folders (ls / dir)
"@

    # ----------------- File / Folder -----------------
    Write-Host "`n[File / Folder Operations]" -ForegroundColor Yellow
    Write-Host @"
New-Item file.txt             # Create new file
New-Item -ItemType Directory MyFolder   # Create new folder
Remove-Item file.txt          # Delete file
Remove-Item -Recurse MyFolder # Delete folder with contents
Copy-Item file.txt newfile.txt # Copy file
Move-Item old.txt new.txt      # Move / rename file
Get-Content file.txt           # Show file content
Set-Content file.txt "Hello"   # Write content to file
Add-Content file.txt "Text"    # Append content to file
"@

    # ----------------- Processes / System -----------------
    Write-Host "`n[Processes / System]" -ForegroundColor Yellow
    Write-Host @"
Get-Process                   # List running processes
Stop-Process -Id <pid>        # Kill process by PID
Start-Process notepad          # Start application
Get-Service                   # List services
Start-Service <name>          # Start service
Stop-Service <name>           # Stop service
"@

    # ----------------- Networking / Utilities -----------------
    Write-Host "`n[Networking / Utilities]" -ForegroundColor Yellow
    Write-Host @"
Test-Connection google.com    # Ping
Resolve-DnsName google.com    # DNS lookup
Get-NetIPAddress              # Show IP addresses
ipconfig /all                 # Network info
curl https://example.com      # HTTP request
"@

    # ----------------- Editing / IDE -----------------
    Write-Host "`n[Editing / IDE]" -ForegroundColor Yellow
    Write-Host @"
notepad file.txt              # Open file in Notepad
code .                        # Open current folder in VS Code
"@

    # ----------------- Scripting / Execution -----------------
    Write-Host "`n[Scripting / Execution]" -ForegroundColor Yellow
    Write-Host @"
.\script.ps1                  # Run PowerShell script
Set-ExecutionPolicy RemoteSigned # Allow running scripts
Get-Command                   # List available commands
Get-Help <command>            # Show command help
Get-Alias                      # Show aliases
"@

    # ----------------- Optional Full Details -----------------
    if ($Full) {
        Write-Host "`n[Advanced / Extras]" -ForegroundColor Yellow
        Write-Host @"
Measure-Command { <code> }    # Measure execution time
Start-Job { <code> }           # Run background job
Receive-Job                    # Get job results
Remove-Job                     # Remove job
Get-History                    # Show command history
Invoke-History <id>            # Run previous command by ID
Export-Csv data.csv            # Export data to CSV
Import-Csv data.csv            # Import CSV
"@
    }

    Write-Host "`n=============================================" -ForegroundColor Cyan
    Write-Host "             END OF POWERSHELL CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
}
