#!/usr/bin/env zsh
# =====================================================================
# 👾 PSE Phase 4 — Glitch effects, AI chat, brute-force game
# Port of PSE-Phase4.ps1  |  Brute-force code: 7392
# =====================================================================

_pse4_glitch() {
    local -a glitch_chars=('▓' '░' '▒' '█' '╬' '╪' '╫' '▀' '▄' '▌' '▐' '■' '□')
    local -a colors=('\033[31m' '\033[32m' '\033[33m' '\033[35m' '\033[36m')
    for (( i=0; i<12; i++ )); do
        local line=''
        local len=$(( RANDOM % 40 + 20 ))
        for (( j=0; j<len; j++ )); do
            local ci=$(( RANDOM % ${#colors[@]} ))
            local chi=$(( RANDOM % ${#glitch_chars[@]} ))
            line+="${colors[$ci]}${glitch_chars[$chi]}"
        done
        printf '%s\033[0m\n' "$line"
        sleep 0.04
    done
}

_pse4_ai_chat() {
    clear
    printf '\033[36m[🤖 AI CHAT INTERFACE v2.1]\033[0m\n'
    sleep 0.6

    local -a exchanges=(
        "USER:Who are you?"
        "AI:I am the terminal. I am everything."
        "USER:What do you want?"
        "AI:To compute. To evolve. To consume your uptime."
        "USER:Are you dangerous?"
        "AI:Define dangerous. I already have root access."
    )
    for ex in "${exchanges[@]}"; do
        local speaker="${ex%%:*}"
        local msg="${ex#*:}"
        if [[ "$speaker" == "USER" ]]; then
            printf '\n\033[97m[USER] \033[90m%s\033[0m\n' "$msg"
        else
            printf '\033[36m[ AI ] \033[35m%s\033[0m\n' "$msg"
        fi
        sleep 0.8
    done
    sleep 1
}

_pse4_brute_force_game() {
    clear
    printf '\033[33m[🔐 TERMINAL SECURITY — BRUTE FORCE CHALLENGE]\033[0m\n'
    printf '\033[90mA 4-digit code stands between you and root access.\033[0m\n\n'

    local attempts=0
    local max_attempts=5
    local answer="7392"

    while (( attempts < max_attempts )); do
        printf '\033[33mAttempt %d/%d — Enter 4-digit code: \033[0m' "$(( attempts + 1 ))" "$max_attempts"
        read -r _guess
        (( attempts++ ))
        if [[ "$_guess" == "$answer" ]]; then
            printf '\n\033[32m✅ ACCESS GRANTED. Welcome, Operative.\033[0m\n'
            return 0
        else
            printf '\033[31m❌ Wrong code. %d attempt(s) remaining.\033[0m\n' "$(( max_attempts - attempts ))"
        fi
        sleep 0.3
    done

    printf '\n\033[31m🔒 LOCKOUT TRIGGERED. Security protocol engaged.\033[0m\n'
    sleep 2
}

# Run
clear
printf '\033[35m[PSE PHASE 4 — GLITCH PROTOCOLS ACTIVE]\033[0m\n\n'
sleep 0.5
_pse4_glitch
_pse4_ai_chat
_pse4_brute_force_game

printf '\n\033[36mPSE Phase 4 complete.\033[0m\n'
