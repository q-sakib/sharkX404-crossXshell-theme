# =====================================================================
# ⏱  Benchmark — time any command, output formatted as X.XXXs
# Uses $EPOCHREALTIME (Zsh 5.8+ built-in, sub-millisecond precision)
# =====================================================================

bench() {
    if [[ $# -eq 0 ]]; then
        printf "${C_YELLOW}Usage: bench <command ...>${C_RESET}\n"; return 1
    fi
    local start=$EPOCHREALTIME
    "$@"
    local exit_code=$?
    local elapsed
    elapsed=$(printf '%.3f' "$(echo "$EPOCHREALTIME - $start" | bc -l)")
    printf "${C_CYAN}%ss${C_RESET}\n" "$elapsed"
    return $exit_code
}
