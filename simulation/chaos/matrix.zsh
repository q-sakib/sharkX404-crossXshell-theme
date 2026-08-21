#!/usr/bin/env zsh
# =====================================================================
# 🟩 matrix.zsh — Matrix rain effect (Ctrl+C to exit)
# Port of matrix.ps1
# =====================================================================

matrix-rain() {
    local cols rows
    cols=$(tput cols 2>/dev/null || echo 80)
    rows=$(tput lines 2>/dev/null || echo 25)

    local -a chars=('0' '1' 'ア' 'イ' 'ウ' 'エ' 'オ' 'カ' 'キ' 'ク' 'ケ' 'コ' 'サ' 'シ' 'ス' 'セ' 'ソ' 'タ' 'チ' 'ツ')
    local -a drops
    local i

    # Initialise drop positions randomly
    for (( i=0; i<cols; i++ )); do
        drops[i]=$(( RANDOM % rows ))
    done

    printf '\033[?25l'      # hide cursor
    printf '\033[2J\033[H'  # clear screen

    trap 'printf "\033[?25h\033[0m\n"; clear; return' INT

    local -a error_msgs=("SYSTEM FAILURE" "ACCESS DENIED" "CORE DUMP" "SEGFAULT" "KERNEL PANIC")
    local frame=0

    while true; do
        for (( i=0; i<cols; i++ )); do
            local row=${drops[i]}
            local ci=$(( RANDOM % ${#chars[@]} ))
            local char="${chars[$ci]}"

            # Move cursor and print
            printf '\033[%d;%dH' "$(( row + 1 ))" "$(( i + 1 ))"
            if (( row == 0 )); then
                printf '\033[97m%s' "$char"   # bright white head
            else
                printf '\033[32m%s' "$char"   # green body
            fi

            # Fade a cell above
            if (( row > 3 )); then
                printf '\033[%d;%dH\033[90m.' "$(( row - 3 ))" "$(( i + 1 ))"
            fi

            drops[i]=$(( (row + 1) % rows ))
        done

        # Random error message overlay
        if (( RANDOM % 40 == 0 )); then
            local ei=$(( RANDOM % ${#error_msgs[@]} ))
            local ex=$(( RANDOM % (rows - 1) + 1 ))
            local ey=$(( RANDOM % (cols - 20) + 1 ))
            printf '\033[%d;%dH\033[31;1m[ %s ]\033[0m' "$ex" "$ey" "${error_msgs[$ei]}"
        fi

        printf '\033[0m'
        sleep 0.04
        (( frame++ ))
    done
}

matrix-rain
