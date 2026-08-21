#Requires -Version 7.0
# =====================================================================
# ⚡ sharkX404 CrossShell Theme — Profile Linker
# Creates a symlink from the PowerShell profile location to this repo.
# Run once after cloning. Re-running is safe (idempotent).
# =====================================================================

$isMac = $IsMacOS -or [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
    [System.Runtime.InteropServices.OSPlatform]::OSX)

# Source: the profile file in this repository
$repoProfile = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path $repoProfile)) {
    Write-Error "❌ Could not locate 'Microsoft.PowerShell_profile.ps1' in $PSScriptRoot"
    exit 1
}

# Destination: the standard PowerShell profile path for this platform
$targetProfile = if ($isMac) {
    Join-Path $HOME ".config/powershell/Microsoft.PowerShell_profile.ps1"
} else {
    Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}

# Ensure the parent directory exists
$targetDir = Split-Path $targetProfile -Parent
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Write-Host "📁 Created profile directory: $targetDir" -ForegroundColor Cyan
}

# Remove any existing file or broken symlink
if (Test-Path $targetProfile) {
    Remove-Item $targetProfile -Force -ErrorAction SilentlyContinue
}

# Try symlink first; fall back to copy if privileges are restricted (non-admin Windows)
try {
    New-Item -ItemType SymbolicLink -Path $targetProfile -Target $repoProfile -Force | Out-Null
    Write-Host "🔗 Linked: $targetProfile" -ForegroundColor Green
    Write-Host "        ➔ $repoProfile" -ForegroundColor DarkGray
} catch {
    Copy-Item -Path $repoProfile -Destination $targetProfile -Force
    Write-Host "📋 Copied profile to: $targetProfile" -ForegroundColor Green
    Write-Host "   (Run as Administrator to use a symlink instead of a copy.)" -ForegroundColor DarkGray
}

Write-Host "`n✅ Profile configured. Restart pwsh or run: . `$PROFILE" -ForegroundColor Green
