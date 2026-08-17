# =====================================================================
# 💻 Platform & Hardware Chip Auto-Configurator (Zsh)
# Apple Silicon (M1/M2/M3/M4) vs Intel Mac Path Detection
# =====================================================================

# Hardware Chip Architecture Detection
get_mac_architecture() {
    if [[ "$(uname)" != "Darwin" ]]; then
        echo "Not-macOS"
        return
    fi
    local sysctl_arm=$(sysctl -n hw.optional.arm64 2>/dev/null)
    if [[ "$sysctl_arm" == "1" ]]; then
        echo "Apple Silicon (ARM64)"
    else
        echo "Intel (x86_64)"
    fi
}

# Auto-inject Homebrew paths dynamically
if [[ "$(uname)" == "Darwin" ]]; then
    typeset -U path
    if [[ -d "/opt/homebrew/bin" ]]; then
        path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
    fi
    if [[ -d "/usr/local/bin" ]]; then
        path=("/usr/local/bin" "/usr/local/sbin" $path)
    fi
    export PATH
fi

sysinfo() {
    echo ""
    echo "🖥️  System & Hardware Diagnostics (Zsh Native):"
    echo "  ─────────────────────────────────────────────────────────────"
    if [[ "$(uname)" == "Darwin" ]]; then
        local chip=$(get_mac_architecture)
        local brew_prefix="/usr/local"
        if [[ -d "/opt/homebrew" ]]; then brew_prefix="/opt/homebrew"; fi
        local rosetta="No (Native)"
        if [[ "$(sysctl -n sysctl.proc_translated 2>/dev/null)" == "1" ]]; then rosetta="Yes (Rosetta 2)"; fi

        echo "  • Operating System : macOS $(sw_vers -productVersion 2>/dev/null)"
        echo "  • CPU Architecture : $chip"
        echo "  • Rosetta Active   : $rosetta"
        echo "  • Homebrew Prefix  : $brew_prefix"
    else
        echo "  • Operating System : $(uname -s)"
        echo "  • Architecture     : $(uname -m)"
    fi
    echo "  • Shell Version    : $ZSH_VERSION"
    echo "  ─────────────────────────────────────────────────────────────"
    echo ""
}

alias mac-arch="sysinfo"
