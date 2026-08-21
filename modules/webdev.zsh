# =====================================================================
# 🌐 Web Dev scaffolding — React, Next, Vue, Angular, Laravel, deploy
# =====================================================================

# ── Project scaffolding ───────────────────────────────────────────────
create-react() { npx create-react-app "${1:-my-app}"; }
create-next()  { npx create-next-app@latest "${1:-my-app}"; }
create-vue()   { npm create vue@latest "${1:-my-app}"; }
ngnew()        { ng new "${1:-my-app}"; }

laravelnew() {
    local name=${1:-my-app}
    if command -v laravel &>/dev/null; then
        laravel new "$name"
    else
        composer create-project laravel/laravel "$name"
    fi
}

# ── Dev server shortcuts ───────────────────────────────────────────────
live() { live-server "${@:-.}"; }
dev()  { npm run dev; }

# ── API testing (httpie) ──────────────────────────────────────────────
api()      { http "$@"; }
api-get()  { http GET "$@"; }
api-post() { http POST "$@"; }

# ── Deploy shortcuts ──────────────────────────────────────────────────
alias deploy-vercel='vercel --prod'
alias deploy-firebase='firebase deploy'
alias deploy-heroku='git push heroku main'
