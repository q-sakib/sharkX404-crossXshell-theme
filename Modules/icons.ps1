# =====================================================================
# 🎨 Icons & Display Fallback Layer
# Provides resilient icon rendering with automatic Nerd Font / ASCII fallbacks
# =====================================================================

function Test-NerdFont {
    <#
    .SYNOPSIS
    Checks if current environment supports Nerd Fonts.
    #>
    if ($env:TERM_PROGRAM -in @('iTerm.app', 'WezTerm', 'Alacritty', 'kitty', 'ghostty', 'vscode')) {
        return $true
    }
    if ($env:WT_SESSION) { # Windows Terminal
        return $true
    }
    return $false
}

# Define symbol mappings for rich UI vs safe ASCII fallback
$script:IconMap = @{
    HasNerdFont = (Test-NerdFont)
    Success     = if (Test-NerdFont) { "✅" } else { "[OK]" }
    Warning     = if (Test-NerdFont) { "⚠️" } else { "[!]" }
    Error       = if (Test-NerdFont) { "❌" } else { "[X]" }
    Folder      = if (Test-NerdFont) { "📁" } else { "[D]" }
    File        = if (Test-NerdFont) { "📄" } else { "[F]" }
    Git         = if (Test-NerdFont) { "🌿" } else { "[GIT]" }
    Rocket      = if (Test-NerdFont) { "🚀" } else { "=>" }
    Tools       = if (Test-NerdFont) { "🛠️" } else { "[TOOL]" }
    Lightning   = if (Test-NerdFont) { "⚡" } else { "*" }
}

function Get-Icon {
    param([string]$name)
    if ($script:IconMap.ContainsKey($name)) {
        return $script:IconMap[$name]
    }
    return ""
}

# ── File Icons & Enhanced 'ls' using Eza ──
if (Get-Command eza -ErrorAction SilentlyContinue) {
    if (Get-Alias ls -ErrorAction SilentlyContinue) { Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue }

    # Define wrapper functions safely
    function global:ls {
        param([Parameter(ValueFromRemainingArguments = $true)]$args)
        if (Test-NerdFont) {
            eza --icons --git --color=auto @args
        } else {
            eza --git --color=auto @args
        }
    }

    function global:ll {
        param([Parameter(ValueFromRemainingArguments = $true)]$args)
        if (Test-NerdFont) {
            eza --icons --git --color=auto -l @args
        } else {
            eza --git --color=auto -l @args
        }
    }

    function global:la {
        param([Parameter(ValueFromRemainingArguments = $true)]$args)
        if (Test-NerdFont) {
            eza --icons --git --color=auto -a @args
        } else {
            eza --git --color=auto -a @args
        }
    }
} else {
    # Fallback if eza is not installed
    if (-not (Get-Command ls -ErrorAction SilentlyContinue)) {
        Set-Alias ls Get-ChildItem
    }
}
