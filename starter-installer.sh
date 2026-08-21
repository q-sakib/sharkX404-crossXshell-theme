#!/usr/bin/env bash
# =====================================================================
# ⚡ sharkX404 CrossShell Theme — macOS Fullstack Dev Installer
# Requires: macOS + Homebrew (auto-installed if missing) + zsh
# =====================================================================

set -e

# ── Colors ────────────────────────────────────────────────────────────
RED='\033[31m'; GREEN='\033[32m'; YELLOW='\033[33m'
CYAN='\033[36m'; GRAY='\033[90m'; RESET='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────
has() { command -v "$1" &>/dev/null; }

brew_install() {
    local cmd=$1 pkg=$2
    if has "$cmd"; then
        printf "${GRAY}  ✅ %-18s already installed.${RESET}\n" "$cmd"
    else
        printf "${YELLOW}  ➡ Installing %s via brew...${RESET}\n" "$pkg"
        brew install "$pkg"
    fi
}

npm_install() {
    local pkg=$1
    if ! has npm; then
        printf "${YELLOW}  ⚠️  npm not found — skipping %s. Restart terminal after Node install.${RESET}\n" "$pkg"
        return
    fi
    if npm list -g --depth=0 2>/dev/null | grep -qF "$pkg"; then
        printf "${GRAY}  ✅ npm:%-14s already installed.${RESET}\n" "$pkg"
    else
        printf "${YELLOW}  ➡ Installing npm package: %s${RESET}\n" "$pkg"
        npm install -g "$pkg"
    fi
}

# ═════════════════════════════════════════════════════════════════════
printf "\n${CYAN}📦 Bootstrapping fullstack dev environment — macOS (Homebrew)${RESET}\n\n"

# ── Homebrew ──────────────────────────────────────────────────────────
if ! has brew; then
    printf "${YELLOW}  ➡ Installing Homebrew...${RESET}\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Inject Homebrew into PATH for this session
    for p in /opt/homebrew/bin /usr/local/bin; do
        [[ -d "$p" && ":$PATH:" != *":$p:"* ]] && export PATH="$p:$PATH"
    done
else
    printf "${GRAY}  ✅ Homebrew already installed.${RESET}\n"
fi

# ═════════════════════════════════════════════════════════════════════
# SECTION 1 — System CLIs
# ═════════════════════════════════════════════════════════════════════
printf "\n${GRAY}── System CLIs ──────────────────────────────────────────────${RESET}\n"

brew_install "gh"          "gh"
brew_install "oh-my-posh"  "jandedobbeleer/oh-my-posh/oh-my-posh"
brew_install "eza"         "eza"
brew_install "fzf"         "fzf"
brew_install "fd"          "fd"
brew_install "bat"         "bat"
brew_install "rg"          "ripgrep"
brew_install "tldr"        "tldr"
brew_install "http"        "httpie"
brew_install "node"        "node"
brew_install "php"         "php"
brew_install "composer"    "composer"
brew_install "zoxide"      "zoxide"
brew_install "jq"          "jq"

# ── zsh plugins via Homebrew ──────────────────────────────────────────
brew install zsh-autosuggestions    2>/dev/null || true
brew install zsh-syntax-highlighting 2>/dev/null || true

# fzf-tab (replaces default Tab completion with fzf)
FZF_TAB_DIR="$HOME/.zsh/fzf-tab"
if [[ ! -d "$FZF_TAB_DIR" ]]; then
    printf "${YELLOW}  ➡ Installing fzf-tab...${RESET}\n"
    git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
    printf "${GREEN}  ✅ fzf-tab installed to %s${RESET}\n" "$FZF_TAB_DIR"
else
    printf "${GRAY}  ✅ fzf-tab already installed.${RESET}\n"
fi

# fzf shell key bindings
if has fzf && [[ ! -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    "$(brew --prefix fzf)/install" --key-bindings --completion --no-update-rc 2>/dev/null || true
fi

# ═════════════════════════════════════════════════════════════════════
# SECTION 2 — Python / HuggingFace CLI
# ═════════════════════════════════════════════════════════════════════
printf "\n${GRAY}── Python / AI CLI ──────────────────────────────────────────${RESET}\n"

if ! has huggingface-cli; then
    if has pip3; then
        printf "${YELLOW}  ➡ Installing huggingface_hub via pip3...${RESET}\n"
        pip3 install huggingface_hub
    elif has pip; then
        printf "${YELLOW}  ➡ Installing huggingface_hub via pip...${RESET}\n"
        pip install huggingface_hub
    else
        printf "${YELLOW}  ⚠️  pip not found. Install Python first, then: pip install huggingface_hub${RESET}\n"
    fi
else
    printf "${GRAY}  ✅ huggingface-cli already installed.${RESET}\n"
fi

# ═════════════════════════════════════════════════════════════════════
# SECTION 3 — Laravel global installer
# ═════════════════════════════════════════════════════════════════════
printf "\n${GRAY}── Laravel ──────────────────────────────────────────────────${RESET}\n"

if has composer && ! has laravel; then
    printf "${YELLOW}  ➡ Installing Laravel installer via composer...${RESET}\n"
    composer global require laravel/installer
    COMPOSER_BIN="$HOME/.composer/vendor/bin"
    if [[ ":$PATH:" != *":$COMPOSER_BIN:"* ]]; then
        # Add to shell profile for future sessions
        echo "export PATH=\"$COMPOSER_BIN:\$PATH\"" >> "$HOME/.zprofile"
        export PATH="$COMPOSER_BIN:$PATH"
        printf "${GREEN}  ✅ Added Composer bin to PATH: %s${RESET}\n" "$COMPOSER_BIN"
        printf "${GRAY}     Restart your terminal for 'laravel' to become available.${RESET}\n"
    fi
elif has laravel; then
    printf "${GRAY}  ✅ laravel installer already installed.${RESET}\n"
else
    printf "${YELLOW}  ⚠️  composer not found — skipping laravel installer.${RESET}\n"
fi

# ═════════════════════════════════════════════════════════════════════
# SECTION 4 — Global npm CLI tools
# ═════════════════════════════════════════════════════════════════════
printf "\n${GRAY}── npm global packages ──────────────────────────────────────${RESET}\n"

npm_clis=(
    "live-server"
    "nodemon"
    "prettier"
    "eslint"
    "@githubnext/copilot-cli"
    "vercel"
    "firebase-tools"
    "next"
    "@angular/cli"
)
for cli in "${npm_clis[@]}"; do npm_install "$cli"; done

# ═════════════════════════════════════════════════════════════════════
# SECTION 5 — Database (optional, interactive)
# ═════════════════════════════════════════════════════════════════════
printf "\n${GRAY}── Database (optional) ──────────────────────────────────────${RESET}\n"
printf "${CYAN}  Choose a database to install:${RESET}\n"
printf "    1. PostgreSQL\n"
printf "    2. MySQL\n"
printf "    3. MongoDB\n"
printf "    4. Skip (default)\n"
printf "  Select [1/2/3/4] or press Enter to skip: "
read -r selection

case "${selection:-4}" in
    1) brew_install "psql"   "postgresql@16" ;;
    2) brew_install "mysql"  "mysql" ;;
    3) brew_install "mongod" "mongodb-community" ;;
    *)
        [[ "${selection:-}" =~ ^[1-4]?$ ]] || \
            printf "${YELLOW}  ⚠️  Unrecognised selection '%s' — skipping.${RESET}\n" "$selection"
        printf "${GRAY}  Skipping database install.${RESET}\n"
        ;;
esac

# ═════════════════════════════════════════════════════════════════════
printf "\n${GREEN}✅ Installation check complete!

Next steps:
  1. Run ./setup-profile.sh   — symlinks ~/.zshrc to this repo
  2. Restart your terminal    — refreshes PATH for newly installed tools
  3. Open zsh and type:
       ghelp       → Git shortcuts reference
       clifuncs    → All loaded custom functions
       Ctrl+R      → Fuzzy command history search
${RESET}\n"
