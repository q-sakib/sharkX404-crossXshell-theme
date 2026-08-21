# =====================================================================
# 🎨 Icons & Display Resilience Layer
# Nerd Font detection with graceful ASCII fallback
# =====================================================================

function Test-NerdFont {
    <#
    .SYNOPSIS
    Returns $true when the current terminal is known to support Nerd Fonts.
    #>
    if ($env:TERM_PROGRAM -in @('iTerm.app', 'WezTerm', 'Alacritty', 'kitty', 'ghostty', 'vscode')) {
        return $true
    }
    if ($env:WT_SESSION) { return $true }   # Windows Terminal
    return $false
}

$script:IconMap = @{
    HasNerdFont = (Test-NerdFont)
    Success     = if (Test-NerdFont) { "✅" } else { "[OK]"   }
    Warning     = if (Test-NerdFont) { "⚠️" } else { "[!]"    }
    Error       = if (Test-NerdFont) { "❌" } else { "[X]"    }
    Folder      = if (Test-NerdFont) { "📁" } else { "[D]"    }
    File        = if (Test-NerdFont) { "📄" } else { "[F]"    }
    Git         = if (Test-NerdFont) { "🌿" } else { "[GIT]"  }
    Rocket      = if (Test-NerdFont) { "🚀" } else { "=>"     }
    Tools       = if (Test-NerdFont) { "🛠️" } else { "[TOOL]" }
    Lightning   = if (Test-NerdFont) { "⚡" } else { "*"      }
}

function Get-Icon {
    param([string]$name)
    if ($script:IconMap.ContainsKey($name)) { return $script:IconMap[$name] }
    return ""
}
