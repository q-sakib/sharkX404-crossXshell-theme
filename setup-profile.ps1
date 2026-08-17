# ---------------------------------------------------------------------
# ⚡ PowerShell Profile Linker & Setup Automation (Cross-Platform)
# ---------------------------------------------------------------------

$isMac = $IsMacOS -or $IsLinux -or ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX))

$repoProfilePath = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path $repoProfilePath)) {
    Write-Host "❌ Could not locate 'Microsoft.PowerShell_profile.ps1' in $PSScriptRoot" -ForegroundColor Red
    exit 1
}

$targetProfilePath = if ($isMac) {
    Join-Path $HOME ".config/powershell/Microsoft.PowerShell_profile.ps1"
} else {
    Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}

$targetDir = Split-Path $targetProfilePath -Parent
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Write-Host "📁 Created profile directory: $targetDir" -ForegroundColor Cyan
}

# Remove existing file or symlink if present
if (Test-Path $targetProfilePath) {
    Remove-Item $targetProfilePath -Force -ErrorAction SilentlyContinue
}

# Create Symlink
try {
    New-Item -ItemType SymbolicLink -Path $targetProfilePath -Target $repoProfilePath -Force | Out-Null
    Write-Host "🔗 Linked profile: $targetProfilePath ➔ $repoProfilePath" -ForegroundColor Green
} catch {
    # Fallback to copy if symlink privileges are restricted
    Copy-Item -Path $repoProfilePath -Destination $targetProfilePath -Force
    Write-Host "📋 Copied profile to: $targetProfilePath" -ForegroundColor Green
}

Write-Host "`n✅ PowerShell profile configured successfully!" -ForegroundColor Green
Write-Host "🚀 Restart pwsh or run '. `$PROFILE' to activate your environment." -ForegroundColor Cyan
