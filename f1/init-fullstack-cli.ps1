# -----------------------------------------
# 🚀 Fullstack PowerShell CLI Bootstrapper
# Windows | macOS | Linux
# -----------------------------------------

$BaseDir = Join-Path (Get-Location) "FullstackCLI"

$Dirs = @(
    "core",
    "core/utils",
    "web",
    "web/db",
    "web/laravel",
    "sim/shark",
    "os"
)

$Files = @{
    "FullstackCLI.psm1" = @"
# Module entry point
`$Script:ModuleRoot = `$PSScriptRoot
`$Script:LoadTimes  = @{}

function Load-WithTiming {
    param(
        [string]`$Name,
        [scriptblock]`$Block
    )

    `$sw = [System.Diagnostics.Stopwatch]::StartNew()
    & `$Block
    `$sw.Stop()

    `$LoadTimes[`$Name] = "`$(`$sw.ElapsedMilliseconds)ms"
}

function Show-FullstackLoadTimes {
    Write-Host "`n⏱ Module Load Times:" -ForegroundColor Cyan
    foreach (`$k in `$LoadTimes.Keys | Sort-Object) {
        Write-Host "• `$k → `$(`$LoadTimes[`$k])" -ForegroundColor Green
    }
}

# ---- CORE (always loaded) ----
. "`$ModuleRoot/core/init.ps1"
. "`$ModuleRoot/core/psreadline.ps1"
. "`$ModuleRoot/core/prompt.ps1"

# ---- OS specific ----
if (`$IsWindows) { . "`$ModuleRoot/os/windows.ps1" }
elseif (`$IsMacOS) { . "`$ModuleRoot/os/macos.ps1" }
elseif (`$IsLinux) { . "`$ModuleRoot/os/linux.ps1" }

# ---- LAZY LOADERS ----
function Enable-Web {
    Load-WithTiming "Web" {
        . "`$ModuleRoot/web/webdev.ps1"
    }
}

function Enable-Laravel {
    Load-WithTiming "Laravel" {
        . "`$ModuleRoot/web/laravel/laravel.ps1"
    }
}

function Enable-DB {
    Load-WithTiming "DB" {
        . "`$ModuleRoot/web/db/db.ps1"
    }
}

function Enable-Sim {
    Load-WithTiming "Simulation" {
        . "`$ModuleRoot/sim/shark/shark-session.ps1"
    }
}

Export-ModuleMember -Function `
    Enable-Web, Enable-Laravel, Enable-DB, Enable-Sim, Show-FullstackLoadTimes
"@

    "FullstackCLI.psd1" = @"
@{
    RootModule        = 'FullstackCLI.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '$(New-Guid)'
    Author            = 'You'
    Description       = 'Cross-platform Fullstack PowerShell CLI'
    PowerShellVersion = '7.2'
}
"@

    "core/init.ps1" = @"
Write-Verbose '🔧 FullstackCLI core initialized'
"@

    "core/psreadline.ps1" = @"
if (Get-Module -ListAvailable PSReadLine) {
    if (`$IsWindows) {
        `$path = "`$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
    } else {
        `$path = "`$HOME/.local/share/powershell/PSReadLine/ConsoleHost_history.txt"
        New-Item -ItemType Directory -Force (Split-Path `$path) | Out-Null
    }

    Set-PSReadLineOption -HistorySavePath `$path -HistoryNoDuplicates
}
"@

    "core/prompt.ps1" = @"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "`$HOME/.poshthemes/paradox.omp.json" | Invoke-Expression
}
"@

    "web/webdev.ps1" = @"
# Paste your existing webdev functions here
"@

    "web/laravel/laravel.ps1" = @"
# Paste your Laravel helpers here
"@

    "web/db/db.ps1" = @"
# Paste your DB helpers here
"@

    "sim/shark/shark-session.ps1" = @"
# Paste your simulation logic here
"@

    "os/windows.ps1" = @"
# Windows-only config
"@

    "os/macos.ps1" = @"
# macOS-only config
Set-Alias ls eza -ErrorAction SilentlyContinue
"@

    "os/linux.ps1" = @"
# Linux-only config
"@
}

# ---------- CREATE STRUCTURE ----------
Write-Host "`n📁 Creating FullstackCLI structure..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $BaseDir -Force | Out-Null

foreach ($dir in $Dirs) {
    New-Item -ItemType Directory -Path (Join-Path $BaseDir $dir) -Force | Out-Null
}

foreach ($file in $Files.Keys) {
    $path = Join-Path $BaseDir $file
    if (-not (Test-Path $path)) {
        $Files[$file] | Out-File $path -Encoding UTF8
        Write-Host "✅ Created $file" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Skipped existing $file" -ForegroundColor Yellow
    }
}

Write-Host "`n🎉 Bootstrap complete!" -ForegroundColor Green
Write-Host "👉 Copy your existing scripts into the generated files."
Write-Host "👉 Import with: Import-Module ./FullstackCLI"
