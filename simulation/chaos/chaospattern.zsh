#!/usr/bin/env zsh
# =====================================================================
# 🌀 chaospattern.zsh — 100 random chaotic lines
# Port of chaospattern.ps1
# =====================================================================

chaos-pattern() {
    local -a chars=('▓' '░' '█' '▒' '╬' '╪' '╫' '╩' '╦' '╣' '║' '╠' '═' '╝' '╚' '╔' '╗' '│' '─' '┼')
    local -a ansi_colors=('\033[31m' '\033[32m' '\033[33m' '\033[34m' '\033[36m' '\033[35m' '\033[97m')

    for (( i=0; i<100; i++ )); do
        local len=$(( RANDOM % 61 + 20 ))  # 20–80 chars
        local line=''
        for (( c=0; c<len; c++ )); do
            local ci=$(( RANDOM % ${#ansi_colors[@]} ))
            local chi=$(( RANDOM % ${#chars[@]} ))
            line+="${ansi_colors[$ci]}${chars[$chi]}"
        done
        printf '%s\033[0m\n' "$line"
        sleep 0.03
    done

    printf "\n\033[33m⚠️  Chaos pattern complete.\033[0m\n"
}

chaos-pattern
