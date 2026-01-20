# Core Setup: Prompt, Icons, Git, Navigation

# 💄 Load prompt theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\easy-term.omp.json" | Invoke-Expression


# 🧠 Autosuggestions + Syntax Highlighting
# 🔠 Syntax highlighting & suggestion
Import-Module PSReadLine


#from-other-terminal----start
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
#from-other-terminal----end




Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -Colors @{
    "Command"   = [ConsoleColor]::Cyan
    "String"    = [ConsoleColor]::Yellow
    "Operator"  = [ConsoleColor]::DarkGray
    "Parameter" = [ConsoleColor]::Green
}

# 🧩 Icons and Git Prompt
# Install-Module Terminal-Icons -Scope CurrentUser -Force
# Import-Module Terminal-Icons -Force -Verbose
# ── File Icons & Enhanced 'ls' using Eza ──
if (Get-Command eza -ErrorAction SilentlyContinue) {

    # Remove built-in alias to allow function override
    if (Get-Alias ls -ErrorAction SilentlyContinue) { Remove-Item Alias:ls }

    # Define ls function wrapping Eza
    Function ls {
        param(
            [Parameter(ValueFromRemainingArguments = $true)]
            $args
        )
        eza --icons --git --color=auto @args
    }

    # Define ll for long listing
    Function ll {
        param(
            [Parameter(ValueFromRemainingArguments = $true)]
            $args
        )
        eza --icons --git --color=auto -l @args
    }

    # Define la for listing all (including hidden)
    Function la {
        param(
            [Parameter(ValueFromRemainingArguments = $true)]
            $args
        )
        eza --icons --git --color=auto -a @args
    }

}
else {
    Write-Host "⚠️ Eza not found. Install via: winget install eza-community.eza" -ForegroundColor Yellow
}

Import-Module posh-git

# 📁 Optional: Smart directory jumping
Import-Module z -ErrorAction SilentlyContinue

# Get current launch location
$currentPath = (Get-Location).Path
$homePath = $env:USERPROFILE
$lastDirPath = Join-Path $homePath ".lastdir"

# 📂 Manual restore of last location
function Restore-LastLocation {
    $lastDirPath = Join-Path $env:USERPROFILE ".lastdir"
    if (Test-Path $lastDirPath) {
        $lastDir = Get-Content $lastDirPath -Raw | ForEach-Object { $_.Trim() }
        if (-not [string]::IsNullOrWhiteSpace($lastDir) -and (Test-Path $lastDir)) {
            Set-Location $lastDir
            Write-Host "✅ Restored last directory: $lastDir"
        } else {
            Write-Warning "⚠️ Saved directory is invalid or missing."
        }
    } else {
        Write-Warning "ℹ️ No saved directory found."
    }
}

# 💾 Save last directory on exit
Register-EngineEvent PowerShell.Exiting -Action {
    try {
        $currentPath = (Get-Location).Path
        Set-Content -Path "$env:USERPROFILE\.lastdir" -Value $currentPath -Encoding UTF8
    } catch {
        Write-Warning "❌ Failed to save last directory: $_"
    }
} | Out-Null


# 📌 Navigation shortcuts
function up { Set-Location .. }
function .. { Set-Location .. }
function ... { Set-Location ../.. }


# 🚀 Project Functions
function codehere { code . }

function jsonpretty {
    param([string]$json)
    $json | ConvertFrom-Json | ConvertTo-Json -Depth 10
}

function live { npx live-server }

function dev { nodemon index.js }







# 🐳 Docker Tools
# 🧠 Help reminder
# Write-Host "`n💡 Terminal Ready! Try:" -ForegroundColor Cyan
# Write-Host "  → live            # Launch live server" -ForegroundColor Gray
# Write-Host "  → deploy-*        # Deploy to Vercel, Firebase, or Heroku" -ForegroundColor Gray
# Write-Host "  → copilot-auth    # GitHub Copilot CLI login" -ForegroundColor Gray
# Write-Host "  → hf-login        # Hugging Face CLI login" -ForegroundColor Gray
# Write-Host "  → api <url>       # Test REST API via httpie" -ForegroundColor Red
# Write-Host "  → fzf             # Start fuzzy file search" -ForegroundColor Gray
# Write-Host "  → deletehistory   # Delete selected history from search" -ForegroundColor Gray
# Write-Host "  → basefuncs       # Show list of some custom utility functions" -ForegroundColor Gray
# Write-Host "  → clifuncs        # Show list of all dev, test, utility & CLI functions" -ForegroundColor Gray



# Write-Host "`n💡 Terminal Ready! Try:" -ForegroundColor Cyan

# # Dev commands
# Write-Host "  → live            # Launch live server" -ForegroundColor Green
# Write-Host "  → deploy-*        # Deploy to Vercel, Firebase, or Heroku" -ForegroundColor DarkCyan

# # Auth
# Write-Host "  → copilot-auth    # GitHub Copilot CLI login" -ForegroundColor Gray
# Write-Host "  → hf-login        # Hugging Face CLI login" -ForegroundColor White

# # API / Testing
# Write-Host "  → api <url>       # Test REST API via httpie" -ForegroundColor Green

# # Tools & utilities
# Write-Host "  → fzf             # Start fuzzy file search" -ForegroundColor DarkGray
# Write-Host "  → deletehistory   # Delete selected history from search" -ForegroundColor Red

# # Function helpers
# Write-Host "  → basefuncs       # Show list of some custom utility functions" -ForegroundColor Blue 
# Write-Host "  → clifuncs        # Show list of all dev, test, utility & CLI functions" -ForegroundColor Magenta 


# ─── END PROFILE ───────────────────────────────────────────────────────
