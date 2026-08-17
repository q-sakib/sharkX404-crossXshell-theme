# =====================================================================
# 💻 Platform & Architecture Detection Layer (Apple Silicon vs Intel vs Windows)
# Dynamic Homebrew PATH injection & Chip Diagnostics
# =====================================================================

function Get-MacArchitecture {
    <#
    .SYNOPSIS
    Returns the hardware architecture of macOS (arm64 for M-series vs x86_64 for Intel).
    #>
    if (-not ($IsMacOS -or ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX)))) {
        return "Not-macOS"
    }

    $arch = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture.ToString().ToLower()

    # Check sysctl for native hardware architecture (handles Rosetta 2 translation)
    $sysctlArch = (sysctl -n hw.optional.arm64 2>$null)
    if ($sysctlArch -eq "1") {
        return "Apple Silicon (ARM64)"
    }
    return "Intel (x86_64)"
}

# ── Homebrew Environment Auto-Configurator ──
if ($IsMacOS -or ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX))) {
    $brewPaths = @(
        "/opt/homebrew/bin",      # Apple Silicon (M1/M2/M3/M4)
        "/opt/homebrew/sbin",
        "/usr/local/bin",         # Intel Mac (x86_64)
        "/usr/local/sbin"
    )

    foreach ($path in $brewPaths) {
        if ((Test-Path $path) -and ($env:PATH -notlike "*$path*")) {
            $env:PATH = "${path}:$($env:PATH)"
        }
    }
}

function sysinfo {
    <#
    .SYNOPSIS
    Displays detailed system, hardware chip architecture, and environment information.
    #>
    $isMac = $IsMacOS -or ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX))

    Write-Host "`n🖥️  System & Hardware Diagnostics:" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray

    if ($isMac) {
        $chip = Get-MacArchitecture
        $brewPrefix = if (Test-Path "/opt/homebrew/bin/brew") { "/opt/homebrew" } else { "/usr/local" }
        $rosetta = if ((sysctl -n sysctl.proc_translated 2>$null) -eq "1") { "Yes (Rosetta 2)" } else { "No (Native)" }

        Write-Host "  • Operating System : " -NoNewline -ForegroundColor Gray
        Write-Host "macOS $(sw_vers -productVersion 2>$null)" -ForegroundColor Green

        Write-Host "  • CPU Architecture : " -NoNewline -ForegroundColor Gray
        Write-Host $chip -ForegroundColor Yellow

        Write-Host "  • Rosetta Active   : " -NoNewline -ForegroundColor Gray
        Write-Host $rosetta -ForegroundColor White

        Write-Host "  • Homebrew Prefix  : " -NoNewline -ForegroundColor Gray
        Write-Host $brewPrefix -ForegroundColor Cyan
    } else {
        Write-Host "  • Operating System : " -NoNewline -ForegroundColor Gray
        Write-Host "$([Environment]::OSVersion)" -ForegroundColor Green

        Write-Host "  • CPU Architecture : " -NoNewline -ForegroundColor Gray
        Write-Host "$env:PROCESSOR_ARCHITECTURE" -ForegroundColor Yellow
    }

    Write-Host "  • PowerShell Vers  : " -NoNewline -ForegroundColor Gray
    Write-Host "$($PSVersionTable.PSVersion)" -ForegroundColor Magenta

    Write-Host "  ─────────────────────────────────────────────────────────────`n" -ForegroundColor DarkGray
}

function mac-arch { sysinfo }
Set-Alias mac-arch sysinfo -ErrorAction SilentlyContinue
