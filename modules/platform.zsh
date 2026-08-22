# =====================================================================
# 🍎 Platform — macOS detection, Homebrew PATH injection, sysinfo
# Load this before all other modules (after icons.zsh).
# =====================================================================

# ── Homebrew PATH injection ───────────────────────────────────────────
for _brew_path in /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/sbin; do
    [[ -d "$_brew_path" && ":$PATH:" != *":$_brew_path:"* ]] && export PATH="$_brew_path:$PATH"
done
unset _brew_path

# ── Composer global bin (laravel, carbon, etc.) ───────────────────────
[[ ":$PATH:" != *":$HOME/.composer/vendor/bin:"* ]] && export PATH="$HOME/.composer/vendor/bin:$PATH"

# ── Architecture detection ────────────────────────────────────────────
_mac_arch() {
    if [[ "$(sysctl -n hw.optional.arm64 2>/dev/null)" == "1" ]]; then
        echo "Apple Silicon (ARM64)"
    else
        echo "Intel (x86_64)"
    fi
}

# ── sysinfo ───────────────────────────────────────────────────────────
sysinfo() {
    local arch
    arch=$(_mac_arch)
    printf "${C_CYAN}System Info${C_RESET}\n"
    printf "  %-16s ${C_WHITE}%s${C_RESET}\n" "Architecture:"  "$arch"
    printf "  %-16s ${C_WHITE}%s${C_RESET}\n" "Hostname:"      "$(hostname)"
    printf "  %-16s ${C_WHITE}%s${C_RESET}\n" "macOS:"         "$(sw_vers -productVersion 2>/dev/null || echo N/A)"
    printf "  %-16s ${C_WHITE}%s${C_RESET}\n" "Shell:"         "$SHELL"
    printf "  %-16s ${C_WHITE}%s${C_RESET}\n" "Zsh version:"   "$ZSH_VERSION"
    printf "  %-16s ${C_WHITE}%s${C_RESET}\n" "PWD:"           "$PWD"
}
alias mac-arch='sysinfo'
