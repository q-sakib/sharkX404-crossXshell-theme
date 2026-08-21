#!/usr/bin/env zsh
# =====================================================================
# 📟 chaos-text.zsh — ASCII art with chaos-style characters + hints
# Port of chaos-text.ps1
# =====================================================================

chaos-text() {
    local -a art=(
        "  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗"
        " ██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔════╝"
        " ██║     ███████║███████║██║   ██║███████╗"
        " ██║     ██╔══██║██╔══██║██║   ██║╚════██║"
        " ╚██████╗██║  ██║██║  ██║╚██████╔╝███████║"
        "  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
        ""
        "         ░░░░░░ TERMINAL CHAOS ░░░░░░"
        ""
        "  ghelp       → all git shortcuts"
        "  clifuncs     → all loaded functions"
        "  Ctrl+R       → fuzzy history search"
        "  bench { }    → time any command"
        "  matrix-rain  → matrix rain (Ctrl+C exit)"
        "  chaos-rain   → chaos frame effect"
        ""
        "  🦈 sharkX404 | native/zsh branch"
    )

    local -a ansi_colors=('\033[31m' '\033[32m' '\033[33m' '\033[34m' '\033[36m' '\033[35m' '\033[97m')

    for line in "${art[@]}"; do
        local ci=$(( RANDOM % ${#ansi_colors[@]} ))
        printf '%s%s\033[0m\n' "${ansi_colors[$ci]}" "$line"
        sleep 0.02
    done
}

chaos-text
