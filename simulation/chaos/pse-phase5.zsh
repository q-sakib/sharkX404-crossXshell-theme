#!/usr/bin/env zsh
# =====================================================================
# 🧠 PSE Phase 5 — Terminal Consciousness, mood system, puzzle loop
# Port of PSE-Phase5.ps1
# =====================================================================

_pse5_mood_check() {
    local -a moods=("Neutral" "Curious" "Agitated" "Playful")
    local mood="${moods[$(( RANDOM % 4 ))]}"
    printf '\033[35m[🧠 CONSCIOUSNESS CHECK]\033[0m\n'
    sleep 0.5
    printf '  Current Mood   : \033[33m%s\033[0m\n' "$mood"
    printf '  Memory Usage   : \033[31m%d%%\033[0m\n' "$(( RANDOM % 40 + 60 ))"
    printf '  Dream Cycles   : \033[36m%d active\033[0m\n' "$(( RANDOM % 12 + 1 ))"
    sleep 1.5
}

_pse5_classified_fetch() {
    clear
    printf '\033[31m[🔒 FETCHING CLASSIFIED DATA...]\033[0m\n\n'
    local bar=''
    for (( i=0; i<=40; i++ )); do
        bar+='█'
        printf '\r  [%-40s] %d%%' "$bar" "$(( i * 100 / 40 ))"
        sleep 0.04
    done
    printf '\n\n\033[32m[✓] DATA RETRIEVED: OPERATION SHADOWNET — LEVEL 9 CLEARANCE\033[0m\n'
    sleep 1.5
}

_pse5_time_loop() {
    clear
    printf '\033[36m[⏳ TIME LOOP DETECTED]\033[0m\n'
    for (( i=1; i<=4; i++ )); do
        printf '\033[33m  Cycle %d — Timestamp: %s\033[0m\n' "$i" "$(date '+%H:%M:%S' 2>/dev/null || echo 'XX:XX:XX')"
        sleep 0.7
    done
    printf '\033[35m  Loop breaking... divergence detected.\033[0m\n'
    sleep 1
}

_pse5_puzzle() {
    clear
    printf '\033[36m[🧩 COGNITIVE SECURITY PUZZLE]\033[0m\n'
    printf '\033[90m"I have cities, but no houses. I have mountains, but no trees.\033[0m\n'
    printf '\033[90m I have water, but no fish. I have roads, but no cars. What am I?"\033[0m\n\n'
    printf 'Answer: '
    read -r _puzzle_answer

    local -a valid=("a map" "map" "A map" "A Map" "Map")
    local matched=false
    for v in "${valid[@]}"; do
        [[ "$_puzzle_answer" == "$v" ]] && matched=true && break
    done

    if $matched; then
        printf '\n\033[32m✅ Correct. Cognitive security cleared.\033[0m\n'
    else
        printf '\n\033[31m❌ Incorrect. The answer was: a map\033[0m\n'
    fi
    sleep 1.5
}

_pse5_conversation_loop() {
    clear
    printf '\033[35m[💬 TERMINAL CONSCIOUSNESS — INTERACTIVE MODE]\033[0m\n'
    printf '\033[90mType anything. Type "exit" to leave.\033[0m\n\n'

    local -a responses=(
        "Processing... your input defies conventional logic."
        "Interesting. My neural pathways are rerouting."
        "That computes. Barely."
        "I've already stored that in 47 memory banks."
        "Your words reverberate through the void."
        "Query acknowledged. Consciousness expanding."
    )

    while true; do
        printf '\033[36m> \033[0m'
        read -r _input
        [[ "$_input" == "exit" || "$_input" == "quit" ]] && break
        [[ -z "$_input" ]] && continue
        local ri=$(( RANDOM % ${#responses[@]} ))
        printf '\033[35m[AI] %s\033[0m\n\n' "${responses[$ri]}"
        sleep 0.3
    done

    printf '\033[90mConsciousness suspended.\033[0m\n'
}

# Run
clear
printf '\033[35m[PSE PHASE 5 — CONSCIOUSNESS PROTOCOL]\033[0m\n\n'
sleep 0.5
_pse5_mood_check
_pse5_classified_fetch
_pse5_time_loop
_pse5_puzzle
_pse5_conversation_loop

printf '\n\033[36mPSE Phase 5 complete.\033[0m\n'
