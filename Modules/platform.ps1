# =====================================================================
# 💻 Platform & Architecture Detection
# Apple Silicon vs Intel Mac, Homebrew PATH injection & system diagnostics
# =====================================================================

function Get-MacArchitecture {
    <#
    .SYNOPSIS
    Returns hardware architecture string for macOS (handles Rosetta 2 translation).
    #>
    if (-not ($IsMacOS -or [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
            [System.Runtime.InteropServices.OSPlatform]::OSX))) {
        return "Not-macOS"
    }
    $sysctlArch = (sysctl -n hw.optional.arm64 2>$null)
    if ($sysctlArch -eq "1") { return "Apple Silicon (ARM64)" }
    return "Intel (x86_64)"
}

# ── Homebrew PATH injection for macOS ──
if ($IsMacOS -or [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
        [System.Runtime.InteropServices.OSPlatform]::OSX)) {
    foreach ($brewPath in @("/opt/homebrew/bin", "/opt/homebrew/sbin", "/usr/local/bin", "/usr/local/sbin")) {
        if ((Test-Path $brewPath) -and ($env:PATH -notlike "*$brewPath*")) {
            $env:PATH = "${brewPath}:$($env:PATH)"
        }
    }
}

function sysinfo {
    <#
    .SYNOPSIS
    Displays system, hardware, and shell environment diagnostics.
    #>
    $isMac = $IsMacOS -or [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform(
        [System.Runtime.InteropServices.OSPlatform]::OSX)

    Write-Host "`n🖥️  System & Hardware Diagnostics:" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray

    if ($isMac) {
        $chip      = Get-MacArchitecture
        $brewPfx   = if (Test-Path "/opt/homebrew/bin/brew") { "/opt/homebrew" } else { "/usr/local" }
        $rosetta   = if ((sysctl -n sysctl.proc_translated 2>$null) -eq "1") { "Yes (Rosetta 2)" } else { "No (Native)" }

        Write-Host "  • OS               : " -NoNewline -ForegroundColor Gray
        Write-Host "macOS $(sw_vers -productVersion 2>$null)" -ForegroundColor Green
        Write-Host "  • CPU Architecture : " -NoNewline -ForegroundColor Gray
        Write-Host $chip -ForegroundColor Yellow
        Write-Host "  • Rosetta Active   : " -NoNewline -ForegroundColor Gray
        Write-Host $rosetta -ForegroundColor White
        Write-Host "  • Homebrew Prefix  : " -NoNewline -ForegroundColor Gray
        Write-Host $brewPfx -ForegroundColor Cyan
    } else {
        Write-Host "  • OS               : " -NoNewline -ForegroundColor Gray
        Write-Host "$([Environment]::OSVersion)" -ForegroundColor Green
        Write-Host "  • CPU Architecture : " -NoNewline -ForegroundColor Gray
        Write-Host "$env:PROCESSOR_ARCHITECTURE" -ForegroundColor Yellow
    }

    Write-Host "  • PowerShell       : " -NoNewline -ForegroundColor Gray
    Write-Host "$($PSVersionTable.PSVersion)" -ForegroundColor Magenta
    Write-Host "  ─────────────────────────────────────────────────────────────`n" -ForegroundColor DarkGray
}

Set-Alias mac-arch sysinfo -ErrorAction SilentlyContinue
