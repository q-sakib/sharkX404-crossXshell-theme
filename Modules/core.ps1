# =====================================================================
# ⚙️ Core Setup: Prompt, Navigation, Keybindings & Environment
# =====================================================================

# 💄 Safe Oh My Posh Prompt Initialization
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    try {
        $themeConfig = if ($env:POSH_THEMES_PATH -and (Test-Path "$env:POSH_THEMES_PATH\easy-term.omp.json")) {
            "$env:POSH_THEMES_PATH\easy-term.omp.json"
        } elseif (Test-Path "$PSScriptRoot/easy-term.omp.json") {
            "$PSScriptRoot/easy-term.omp.json"
        } else {
            "easy-term"
        }
        oh-my-posh init pwsh --config $themeConfig | Invoke-Expression
    } catch {
        Write-Verbose "Oh My Posh theme fallback active."
    }
}

# 🧠 PSReadLine Configuration
if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    try {
        Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
        Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
        Set-PSReadLineOption -Colors @{
            "Command"   = [ConsoleColor]::Cyan
            "String"    = [ConsoleColor]::Yellow
            "Operator"  = [ConsoleColor]::DarkGray
            "Parameter" = [ConsoleColor]::Green
        } -ErrorAction SilentlyContinue
    } catch {}
}

# 📁 Cross-Platform Home & Directory Restoration
$homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
$lastDirPath = Join-Path $homePath ".lastdir"

function Restore-LastLocation {
    $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
    $lastDirPath = Join-Path $homePath ".lastdir"
    if (Test-Path $lastDirPath) {
        $lastDir = Get-Content $lastDirPath -Raw -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() }
        if (-not [string]::IsNullOrWhiteSpace($lastDir) -and (Test-Path $lastDir)) {
            Set-Location $lastDir
            Write-Host "✅ Restored last directory: $lastDir" -ForegroundColor Green
        } else {
            Write-Warning "⚠️ Saved directory is invalid or missing."
        }
    } else {
        Write-Warning "ℹ️ No saved directory found."
    }
}

# Save last directory on exit
Register-EngineEvent PowerShell.Exiting -Action {
    try {
        $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
        $currentPath = (Get-Location).Path
        Set-Content -Path (Join-Path $homePath ".lastdir") -Value $currentPath -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch {}
} -ErrorAction SilentlyContinue | Out-Null

# 📌 Navigation shortcuts
function up  { Set-Location .. }
function ..  { Set-Location .. }
function ... { Set-Location ../.. }

# 🚀 Quick Project Shortcuts
function codehere { code . }
function jsonpretty {
    param([string]$json)
    if (-not $json) {
        Write-Host "Usage: jsonpretty '<json-string>'"
        return
    }
    $json | ConvertFrom-Json | ConvertTo-Json -Depth 10
}
function live { npx live-server }
function dev  { param([string]$file = "index.js") nodemon $file }

# Optional Smart Directory Jumping & Posh-Git
Import-Module posh-git -ErrorAction SilentlyContinue
Import-Module z -ErrorAction SilentlyContinue
