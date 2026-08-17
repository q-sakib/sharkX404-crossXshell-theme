# =====================================================================
# 🟢 Node.js, NPM & Package Management Shortcuts (Zsh)
# =====================================================================

alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrt="npm test"

# Clean node_modules & lockfile
nclean() {
    echo "🧹 Removing node_modules and package-lock.json..."
    rm -rf node_modules package-lock.json yarn.lock pnpm-lock.yaml
    echo "✅ Cleaned."
}
