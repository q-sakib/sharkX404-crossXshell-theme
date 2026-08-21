#!/usr/bin/env zsh
# =====================================================================
# 💥 chaos.zsh — 200 frames of random chaos (Ctrl+C to stop)
# Port of chaos.ps1
# =====================================================================

chaos-rain() {
    local -a chaos_chars=('!' '@' '#' '$' '%' '^' '&' '*' '(' ')' '-' '+' '=' '[' ']' '{' '}' '|' ':' ';' '<' '>' ',' '.' '/' '?' '~' '`')
    local -a ansi_colors=('\033[31m' '\033[32m' '\033[33m' '\033[34m' '\033[36m' '\033[35m' '\033[97m')
    local cols rows frame line
    cols=$(tput cols 2>/dev/null || echo 100)
    rows=$(tput lines 2>/dev/null || echo 50)
    [[ $cols -gt 100 ]] && cols=100
    [[ $rows -gt 50 ]] && rows=50

    printf '\033[?25l'  # hide cursor
    trap 'printf "\033[?25h\033[0m\n"; return' INT

    for (( frame=0; frame<200; frame++ )); do
        for (( line=0; line<rows; line++ )); do
            local row_str=''
            for (( col=0; col<cols; col++ )); do
                if (( RANDOM % 20 == 0 )); then
                    row_str+='ERROR '
                else
                    local ci=$(( RANDOM % ${#ansi_colors[@]} ))
                    local chi=$(( RANDOM % ${#chaos_chars[@]} ))
                    row_str+="${ansi_colors[$ci]}${chaos_chars[$chi]}"
                fi
            done
            printf '%s\033[0m\n' "$row_str"
        done
        sleep 0.05
        printf '\033[%dA' "$rows"  # move cursor back up
    done

    printf '\033[?25h\033[0m'  # restore cursor
    printf '\033[%dB\n' "$rows"
}

chaos-rain
