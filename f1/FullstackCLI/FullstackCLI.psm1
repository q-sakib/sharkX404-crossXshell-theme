# Module entry point
$Script:ModuleRoot = $PSScriptRoot
$Script:LoadTimes  = @{}

function Load-WithTiming {
    param(
        [string]$Name,
        [scriptblock]$Block
    )

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    & $Block
    $sw.Stop()

    $LoadTimes[$Name] = "$($sw.ElapsedMilliseconds)ms"
}

function Show-FullstackLoadTimes {
    Write-Host "
⏱ Module Load Times:" -ForegroundColor Cyan
    foreach ($k in $LoadTimes.Keys | Sort-Object) {
        Write-Host "• $k → $($LoadTimes[$k])" -ForegroundColor Green
    }
}

# ---- CORE (always loaded) ----
. "$ModuleRoot/core/init.ps1"
. "$ModuleRoot/core/psreadline.ps1"
. "$ModuleRoot/core/prompt.ps1"

# ---- OS specific ----
if ($IsWindows) { . "$ModuleRoot/os/windows.ps1" }
elseif ($IsMacOS) { . "$ModuleRoot/os/macos.ps1" }
elseif ($IsLinux) { . "$ModuleRoot/os/linux.ps1" }

# ---- LAZY LOADERS ----
function Enable-Web {
    Load-WithTiming "Web" {
        . "$ModuleRoot/web/webdev.ps1"
    }
}

function Enable-Laravel {
    Load-WithTiming "Laravel" {
        . "$ModuleRoot/web/laravel/laravel.ps1"
    }
}

function Enable-DB {
    Load-WithTiming "DB" {
        . "$ModuleRoot/web/db/db.ps1"
    }
}

function Enable-Sim {
    Load-WithTiming "Simulation" {
        . "$ModuleRoot/sim/shark/shark-session.ps1"
    }
}

Export-ModuleMember -Function 
    Enable-Web, Enable-Laravel, Enable-DB, Enable-Sim, Show-FullstackLoadTimes
