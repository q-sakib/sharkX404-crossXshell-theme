# =====================================================================
# ⚙️ Core Navigation & Web Dev Utilities (Zsh)
# =====================================================================

alias up="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias codehere="code ."
alias live="npx live-server"

dev() {
    local file="${1:-index.js}"
    nodemon "$file"
}

jsonpretty() {
    if [[ -z "$1" ]]; then
        echo "Usage: jsonpretty '<json-string>'"
        return 1
    fi
    if command -v jq >/dev/null 2>&1; then
        echo "$1" | jq .
    else
        python3 -m json.tool <<< "$1"
    fi
}
