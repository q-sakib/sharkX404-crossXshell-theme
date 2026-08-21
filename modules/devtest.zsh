# =====================================================================
# 🧪 Dev Testing — HTTP, JSON, ports, processes, local servers
# =====================================================================

# ── Process management ────────────────────────────────────────────────
psg() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: psg <name>${C_RESET}\n"; return 1; fi
    ps aux | grep -i "$1" | grep -v grep
}

pk() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: pk <name>${C_RESET}\n"; return 1; fi
    local pids
    pids=$(psg "$1" | awk '{print $2}')
    if [[ -z "$pids" ]]; then
        printf "${C_YELLOW}No process found matching: %s${C_RESET}\n" "$1"; return 1
    fi
    echo "$pids" | while read -r pid; do
        kill "$pid" && printf "${C_GREEN}  Killed PID %s${C_RESET}\n" "$pid"
    done
}

# ── Port management ───────────────────────────────────────────────────
portcheck() {
    local port=${1:-}
    if [[ -z "$port" ]]; then printf "${C_YELLOW}Usage: portcheck <port>${C_RESET}\n"; return 1; fi
    local result
    result=$(lsof -i ":$port" 2>/dev/null)
    if [[ -n "$result" ]]; then
        printf "${C_YELLOW}Port %s is IN USE:${C_RESET}\n" "$port"
        echo "$result"
    else
        printf "${C_GREEN}Port %s is FREE.${C_RESET}\n" "$port"
    fi
}

portopen() {
    local host=${1:-localhost} port=${2:-80}
    nc -zv "$host" "$port" 2>&1 && printf "${C_GREEN}  Open${C_RESET}\n" || printf "${C_RED}  Closed${C_RESET}\n"
}

ports() {
    printf "${C_CYAN}Listening ports:${C_RESET}\n"
    lsof -i -P -n | grep LISTEN | awk '{printf "  %-8s %-30s %s\n", $2, $1, $9}'
}

# ── HTTP / curl shortcuts ─────────────────────────────────────────────
# jget <url> — GET with JSON response pretty-printed
jget() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: jget <url> [header...]${C_RESET}\n"; return 1; fi
    local url=$1; shift
    curl -s -H "Accept: application/json" "$@" "$url" | jq .
}

# jpost <url> <json-body> [headers]
jpost() {
    if [[ -z "$1" || -z "$2" ]]; then
        printf "${C_YELLOW}Usage: jpost <url> '<json>' [header...]${C_RESET}\n"; return 1
    fi
    local url=$1 body=$2; shift 2
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "$body" "$@" "$url" | jq .
}

# jput <url> <json-body>
jput() {
    if [[ -z "$1" || -z "$2" ]]; then
        printf "${C_YELLOW}Usage: jput <url> '<json>'${C_RESET}\n"; return 1
    fi
    curl -s -X PUT \
        -H "Content-Type: application/json" \
        -d "$2" "$1" | jq .
}

# jdel <url>
jdel() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: jdel <url>${C_RESET}\n"; return 1; fi
    curl -s -X DELETE "$1" | jq .
}

# httpstatus <url> — just the status code
httpstatus() {
    if [[ -z "$1" ]]; then printf "${C_YELLOW}Usage: httpstatus <url>${C_RESET}\n"; return 1; fi
    local code
    code=$(curl -o /dev/null -s -w "%{http_code}" "$1")
    local color
    case "${code:0:1}" in
        2) color=$C_GREEN ;;
        3) color=$C_CYAN ;;
        4) color=$C_YELLOW ;;
        5) color=$C_RED ;;
        *) color=$C_GRAY ;;
    esac
    printf "${color}%s${C_RESET}  %s\n" "$code" "$1"
}

# headers <url> — show response headers only
headers() {
    curl -I -s "$1"
}

# ── JSON tools ────────────────────────────────────────────────────────
# jpp — pretty-print JSON from stdin or clipboard
jpp() {
    if [[ -t 0 ]]; then
        pbpaste | jq .
    else
        jq .
    fi
}

# jwt-decode <token> — decode JWT payload (no verification)
jwt-decode() {
    local token=${1:-}
    if [[ -z "$token" ]]; then printf "${C_YELLOW}Usage: jwt-decode <jwt-token>${C_RESET}\n"; return 1; fi
    local payload
    payload=$(echo "$token" | cut -d'.' -f2)
    # Add padding if needed
    local padded="${payload}$(printf '%*s' $(( (4 - ${#payload} % 4) % 4 )) '' | tr ' ' '=')"
    echo "$padded" | base64 -d 2>/dev/null | jq .
}

# ── Local servers ─────────────────────────────────────────────────────
# serve [port] — static file server via Python
serve() {
    local port=${1:-8000}
    printf "${C_CYAN}Serving on http://localhost:%s — Ctrl+C to stop${C_RESET}\n" "$port"
    python3 -m http.server "$port"
}

# ── SSL check ─────────────────────────────────────────────────────────
ssl-check() {
    local host=${1:-}
    if [[ -z "$host" ]]; then printf "${C_YELLOW}Usage: ssl-check <hostname>${C_RESET}\n"; return 1; fi
    echo | openssl s_client -connect "$host:443" 2>/dev/null | openssl x509 -noout -subject -dates -issuer
}

# ── Watching ──────────────────────────────────────────────────────────
# watch-cmd <interval> <command> — run command every N seconds
watch-cmd() {
    local interval=${1:-2}; shift
    if [[ $# -eq 0 ]]; then printf "${C_YELLOW}Usage: watch-cmd <seconds> <command>${C_RESET}\n"; return 1; fi
    printf "${C_CYAN}Running every %ss — Ctrl+C to stop: %s${C_RESET}\n" "$interval" "$*"
    while true; do
        clear
        printf "${C_GRAY}[%s] %s${C_RESET}\n\n" "$(date '+%H:%M:%S')" "$*"
        eval "$@"
        sleep "$interval"
    done
}

# ── Environment check ─────────────────────────────────────────────────
# envcheck — show which dev tools are installed
envcheck() {
    printf "\n${C_CYAN}🔍 Dev Environment Check:${C_RESET}\n"
    local tools=(node npm npx php composer python3 pip3 ruby go docker gh fzf bat eza fd rg jq curl http)
    for t in "${tools[@]}"; do
        if command -v "$t" &>/dev/null; then
            local ver
            ver=$("$t" --version 2>/dev/null | head -1 | cut -c1-50)
            printf "  ${C_GREEN}✅ %-12s${C_RESET} ${C_GRAY}%s${C_RESET}\n" "$t" "$ver"
        else
            printf "  ${C_RED}❌ %-12s${C_RESET} ${C_GRAY}not installed${C_RESET}\n" "$t"
        fi
    done
    printf "\n"
}

# ── Network ───────────────────────────────────────────────────────────
alive() { ping -c 3 "${1:-google.com}"; }
localip() { ipconfig getifaddr en0 2>/dev/null || ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'; }
