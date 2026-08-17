# =====================================================================
# 🐳 Docker, API & Utility Helpers (Zsh)
# =====================================================================

# Docker Aliases
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dclean="docker system prune -a -f"

dlog() {
    docker logs -f "$@"
}

# API Testing Helper
api() {
    if command -v http >/dev/null 2>&1; then
        http "$@"
    else
        echo "⚠️ 'httpie' not found. Install via: brew install httpie"
        curl -s "$@"
    fi
}

myip() {
    curl -s "https://ipinfo.io/json"
}

load-env() {
    if [[ -f .env ]]; then
        export $(grep -v '^#' .env | xargs)
        echo "✅ .env file loaded into environment."
    else
        echo "⚠️ No .env file found in current directory."
    fi
}

alias edit-env="code .env"
alias edit-config="code .vscode/settings.json"
