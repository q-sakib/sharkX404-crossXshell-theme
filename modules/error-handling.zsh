# =====================================================================
# 🛡  Error handling — try-run wrapper with success/failure output
# =====================================================================

try-run() {
    if [[ $# -eq 0 ]]; then
        printf "${C_YELLOW}Usage: try-run <command ...>${C_RESET}\n"; return 1
    fi
    "$@"
    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        printf "${C_GREEN}✅ Success${C_RESET}\n"
    else
        printf "${C_RED}❌ Failed with exit code: %d${C_RESET}\n" "$exit_code"
    fi
    return $exit_code
}
