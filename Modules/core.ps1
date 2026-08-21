# =====================================================================
# ⚙️ Core Setup: Prompt, PSReadLine, Navigation & Environment
# =====================================================================

# 💄 Safe Oh My Posh Prompt Initialization
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    try {
        $themeConfig = if ($env:POSH_THEMES_PATH -and (Test-Path "$env:POSH_THEMES_PATH\easy-term.omp.json")) {
            "$env:POSH_THEMES_PATH\easy-term.omp.json"
        } else {
            "easy-term"
        }
        oh-my-posh init pwsh --config $themeConfig | Invoke-Expression
    } catch {
        Write-Verbose "Oh My Posh theme fallback active."
    }
}

# 🧠 PSReadLine Configuration
Import-Module PSReadLine -ErrorAction SilentlyContinue
if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    try {
        Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
        Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
        Set-PSReadLineOption -HistoryNoDuplicates:$true -ErrorAction SilentlyContinue
        Set-PSReadLineOption -Colors @{
            "Command"   = [ConsoleColor]::Cyan
            "String"    = [ConsoleColor]::Yellow
            "Operator"  = [ConsoleColor]::DarkGray
            "Parameter" = [ConsoleColor]::Green
        } -ErrorAction SilentlyContinue
    } catch {}
}

# Chocolatey tab-completion (Windows only)
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}

# ── File Icons & Enhanced 'ls' using Eza (fallback to Get-ChildItem) ──
if (Get-Command eza -ErrorAction SilentlyContinue) {
    if (Get-Alias ls -ErrorAction SilentlyContinue) { Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue }

    function global:ls {
        param([Parameter(ValueFromRemainingArguments = $true)]$args)
        eza --icons --git --color=auto @args
    }
    function global:ll {
        param([Parameter(ValueFromRemainingArguments = $true)]$args)
        eza --icons --git --color=auto -l @args
    }
    function global:la {
        param([Parameter(ValueFromRemainingArguments = $true)]$args)
        eza --icons --git --color=auto -a @args
    }
} else {
    if (-not (Get-Alias ls -ErrorAction SilentlyContinue)) {
        Set-Alias ls Get-ChildItem
    }
    function global:ll { param([Parameter(ValueFromRemainingArguments = $true)]$args) Get-ChildItem @args }
    function global:la { param([Parameter(ValueFromRemainingArguments = $true)]$args) Get-ChildItem -Force @args }
    Write-Verbose "eza not found — using Get-ChildItem. Install: winget install eza-community.eza"
}

# 🧩 Git Prompt & Smart Jump
Import-Module posh-git -ErrorAction SilentlyContinue
Import-Module z -ErrorAction SilentlyContinue

# 📂 Restore last working directory (call manually: Restore-LastLocation)
function Restore-LastLocation {
    $homePath  = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
    $savedPath = Join-Path $homePath ".lastdir"
    if (Test-Path $savedPath) {
        $lastDir = (Get-Content $savedPath -Raw -ErrorAction SilentlyContinue).Trim()
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

# 💾 Save last directory on shell exit
Register-EngineEvent PowerShell.Exiting -Action {
    try {
        $homePath = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
        Set-Content -Path (Join-Path $homePath ".lastdir") -Value (Get-Location).Path -Encoding UTF8
    } catch {}
} -ErrorAction SilentlyContinue | Out-Null

# 📌 Navigation shortcuts
function up  { Set-Location .. }
function ..  { Set-Location .. }
function ... { Set-Location ../.. }

# 🛠 Quick editor shortcut
function codehere { code . }
