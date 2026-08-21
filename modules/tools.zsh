# =====================================================================
# 🛠  Tools — file search, grep, preview, network, env helpers
# =====================================================================

# ── File search ───────────────────────────────────────────────────────
ff() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: ff <filename>${C_RESET}\n"; return 1; fi
    if command -v fd &>/dev/null; then
        fd "$1"
    else
        find . -name "*$1*" 2>/dev/null
    fi
}

# ── grep → ripgrep ────────────────────────────────────────────────────
command -v rg &>/dev/null && alias grep='rg'

# ── File preview → bat ────────────────────────────────────────────────
if command -v bat &>/dev/null; then
    alias preview='bat'
    alias cat='bat --paging=never'
else
    alias preview='cat'
fi

# ── Network ───────────────────────────────────────────────────────────
myip() { curl -s https://api.ipify.org && echo; }

# ── .env loader ───────────────────────────────────────────────────────
load-env() {
    local envfile=${1:-.env}
    if [[ ! -f "$envfile" ]]; then
        printf "${C_YELLOW}Not found: %s${C_RESET}\n" "$envfile"; return 1
    fi
    local count=0
    while IFS='=' read -r key val; do
        [[ "$key" =~ ^[[:space:]]*# || -z "$key" ]] && continue
        val="${val%\"}"
        val="${val#\"}"
        val="${val%\'}"
        val="${val#\'}"
        export "$key"="$val"
        (( count++ ))
    done < "$envfile"
    printf "${C_GREEN}✅ Loaded %d variables from %s${C_RESET}\n" "$count" "$envfile"
}

# ── Config editors ────────────────────────────────────────────────────
edit-env() {
    ${EDITOR:-nano} "${1:-.env}"
}

edit-config() {
    ${EDITOR:-nano} ~/.zshrc
}

# ── Open URL ──────────────────────────────────────────────────────────
open-url() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: open-url <url>${C_RESET}\n"; return 1; fi
    if command -v open &>/dev/null; then
        open "$1"
    elif command -v xdg-open &>/dev/null; then
        xdg-open "$1"
    else
        printf "${C_YELLOW}Cannot open URL — 'open' not available.${C_RESET}\n"
    fi
}
