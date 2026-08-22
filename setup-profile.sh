#!/usr/bin/env zsh
# =====================================================================
# ⚡ sharkX404 CrossShell Theme — Zsh Profile Linker
# Creates a symlink from ~/.zshrc to this repo's .zshrc.
# Run once after cloning. Re-running is safe (idempotent).
# =====================================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ZSHRC="$REPO_DIR/.zshrc"
TARGET_ZSHRC="$HOME/.zshrc"

if [[ ! -f "$REPO_ZSHRC" ]]; then
    printf '\033[31m❌ Could not locate .zshrc in %s\033[0m\n' "$REPO_DIR"
    exit 1
fi

# Back up any existing .zshrc that is NOT already pointing to this repo
if [[ -f "$TARGET_ZSHRC" && ! -L "$TARGET_ZSHRC" ]]; then
    backup="${TARGET_ZSHRC}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$TARGET_ZSHRC" "$backup"
    printf '\033[33m📦 Backed up existing .zshrc → %s\033[0m\n' "$backup"
fi

# Remove any existing symlink (stale or pointing elsewhere)
[[ -L "$TARGET_ZSHRC" ]] && rm -f "$TARGET_ZSHRC"

# Create symlink
ln -s "$REPO_ZSHRC" "$TARGET_ZSHRC"
printf '\033[32m🔗 Linked: %s\033[0m\n' "$TARGET_ZSHRC"
printf '\033[90m        ➔ %s\033[0m\n' "$REPO_ZSHRC"

# ── Simulation preference ─────────────────────────────────────────────
printf '\n\033[36m🦈 Show startup simulation (shark swim + welcome screen)? [Y/n] \033[0m'
read -r _sim_ans
if [[ "${_sim_ans}" =~ ^[Nn]$ ]]; then
    printf 'SHARK_SIMULATION=0\n' > "$HOME/.shark_prefs"
    printf '\033[33m   Simulation disabled.\033[0m\n'
    printf '\033[90m   Re-enable anytime: echo "SHARK_SIMULATION=1" > ~/.shark_prefs\033[0m\n'
else
    printf 'SHARK_SIMULATION=1\n' > "$HOME/.shark_prefs"
    printf '\033[32m   ✅ Simulation enabled.\033[0m\n'
fi

printf '\n\033[32m✅ Profile configured. Open a new terminal or run: source ~/.zshrc\033[0m\n'
