# =====================================================================
# ⚙️ Core Navigation, Dev Helpers & Function Listings (Zsh)
# 100% Identical to PowerShell setup for seamless cross-shell workflow
# =====================================================================

# 📌 Navigation shortcuts
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

basefuncs() {
    echo "🛠️  Base Utility Functions:"
    echo "  up            - Navigate up one directory"
    echo "  ..            - Navigate up one directory"
    echo "  ...           - Navigate up two directories"
    echo "  codehere      - Open VS Code in current folder"
    echo "  jsonpretty    - Format JSON strings"
    echo "  live          - Launch live-server"
    echo "  dev           - Run nodemon on target file"
    echo "  api           - Send REST API request via httpie/curl"
    echo "  ghelp         - Show full Git alias reference"
    echo "  sysinfo       - Hardware architecture & chip diagnostics"
    echo "  deletehistory - Interactively delete history items via fzf"
    echo "  clifuncs      - List all custom dev CLI functions"
}

list-dev-functions() {
    echo ""
    echo "🛠️  Custom CLI Functions Loaded (Zsh):"
    echo "  ─────────────────────────────────────────────────────────────"
    local funcs=(
        "api" "api-get" "api-post" "art" "art-dbseed" "art-make-controller"
        "art-make-middleware" "art-make-migration" "art-make-model" "art-migrate"
        "art-migrate-rollback" "art-serve" "basefuncs" "clean-history" "clifuncs"
        "codehere" "create-next" "create-react" "create-vue" "dc" "dcd" "dclean"
        "dcu" "deletehistory" "deploy-firebase" "deploy-heroku" "deploy-vercel"
        "dev" "dlog" "edit-config" "edit-env" "ff" "ga" "gaa" "gb" "gba" "gbd"
        "gbD" "gcb" "gclean" "gco" "gc" "gd" "gds" "gf" "git-aliases" "ghelp"
        "gll" "glog" "gp" "gpf" "gpl" "gplr" "gprune" "greset" "gs" "gst" "gstl"
        "gstp" "gundo" "hf-login" "jsonpretty" "la" "laravelnew" "live" "ll"
        "load-env" "ls" "mac-arch" "make-express-boilerplate" "make-jwt-setup"
        "make-mongo-connection" "make-mongoose-model" "make-prisma-model" "myip"
        "nextbuild" "nextdev" "nextexport" "nextnew" "nextstart" "ngbuild" "ngg"
        "ngnew" "ngserve" "ngt" "open-url" "preview" "prisma-generate" "prisma-init"
        "prisma-migrate" "prisma-pull" "prisma-studio" "sysinfo" "up"
    )

    for fn in "${funcs[@]}"; do
        printf "  • %-28s\n" "$fn"
    done
    echo "  ─────────────────────────────────────────────────────────────"
    echo "🧭 Total: ${#funcs[@]} custom functions & aliases loaded"
    echo "🔍 Tip: Use 'ghelp' for Git shortcuts or 'sysinfo' for chip diagnostics."
    echo ""
}

alias list-dev-functions="list-dev-functions"
alias clifuncs="list-dev-functions"
