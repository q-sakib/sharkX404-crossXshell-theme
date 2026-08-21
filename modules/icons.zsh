# =====================================================================
# 🎨 Icon & Color Foundation
# Detects Nerd Font support and exports icon/color variables.
# Load this before all other modules.
# =====================================================================

_test_nerd_font() {
    [[ "$TERM_PROGRAM" =~ ^(iTerm.app|WezTerm|Alacritty|kitty|ghostty|vscode)$ ]] && return 0
    [[ -n "$WT_SESSION" ]] && return 0
    return 1
}

if _test_nerd_font; then
    ICON_SUCCESS="✅"
    ICON_ERROR="❌"
    ICON_GIT="🌿"
    ICON_FOLDER="📁"
    ICON_FILE="📄"
    ICON_STAR="⭐"
    ICON_ROCKET="🚀"
    ICON_CHERRY="🍒"
    ICON_WARN="⚠️"
    ICON_LOCK="🔒"
    ICON_HINT="💡"
    ICON_TRASH="🗑"
    ICON_PACKAGE="📦"
    ICON_SHARK="🦈"
    ICON_TOOLS="🛠"
    ICON_CHECK="✔"
    ICON_ARROW="→"
else
    ICON_SUCCESS="[OK]"
    ICON_ERROR="[ERR]"
    ICON_GIT="[GIT]"
    ICON_FOLDER="[DIR]"
    ICON_FILE="[FILE]"
    ICON_STAR="[*]"
    ICON_ROCKET="[>>]"
    ICON_CHERRY="[cp]"
    ICON_WARN="[!!]"
    ICON_LOCK="[lock]"
    ICON_HINT="[?]"
    ICON_TRASH="[del]"
    ICON_PACKAGE="[pkg]"
    ICON_SHARK="[>]"
    ICON_TOOLS="[fn]"
    ICON_CHECK="[v]"
    ICON_ARROW="->"
fi

unset -f _test_nerd_font

# ANSI color helpers — use these instead of raw escape sequences
C_RED='\033[31m'
C_GREEN='\033[32m'
C_YELLOW='\033[33m'
C_BLUE='\033[34m'
C_MAGENTA='\033[35m'
C_CYAN='\033[36m'
C_WHITE='\033[97m'
C_GRAY='\033[90m'
C_BOLD='\033[1m'
C_RESET='\033[0m'
