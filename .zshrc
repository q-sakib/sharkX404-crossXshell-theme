# =====================================================================
# 🦈 sharkX404 CrossShell Theme — Zsh Native Profile
# macOS-optimized  |  Oh My Posh  |  eza  |  fzf  |  zsh-autosuggestions
# =====================================================================

# ── 0. Resolve repo root (handles symlinks) ──────────────────────────
_resolve_profile_dir() {
    local zshrc="$HOME/.zshrc"
    if [[ -L "$zshrc" ]]; then
        local target
        target=$(readlink "$zshrc")
        [[ "$target" != /* ]] && target="$(dirname "$zshrc")/$target"
        dirname "$target"
    else
        dirname "$zshrc"
    fi
}
_PROFILE_DIR="$(_resolve_profile_dir)"
unset -f _resolve_profile_dir

# ── 0a. zsh-autocomplete — MUST be first, before any ZLE hook ────────
# Shows a live dropdown list of up to 10 matching history entries as you type
for _ac in \
    /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh \
    "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"; do
    [[ -f "$_ac" ]] && { source "$_ac"; break; }
done
unset _ac
# Configure the live list
zstyle ':autocomplete:*' list-lines 10
zstyle ':autocomplete:history-search:*' list-lines 10
zstyle ':autocomplete:history-incremental-search-*:*' list-lines 10
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' delay 0.05
zstyle ':autocomplete:*' recent-dirs off

# ── 1. Load foundation modules first ─────────────────────────────────
for _mod in icons.zsh platform.zsh; do
    _mod_path="$_PROFILE_DIR/modules/$_mod"
    [[ -f "$_mod_path" ]] && source "$_mod_path"
done

# ── 2. Load all remaining modules ────────────────────────────────────
for _mod_path in "$_PROFILE_DIR"/modules/*.zsh; do
    _mod_name="${_mod_path:t}"
    [[ "$_mod_name" == "icons.zsh" || "$_mod_name" == "platform.zsh" ]] && continue
    [[ -f "$_mod_path" ]] && source "$_mod_path"
done
unset _mod _mod_path _mod_name

# ── 3. Run startup simulation ─────────────────────────────────────────
_sim="$_PROFILE_DIR/simulation/shark/shark-session.zsh"
[[ -f "$_sim" ]] && source "$_sim" && run-startup-welcome
unset _sim

# ── 4. Welcome line ───────────────────────────────────────────────────
printf '\n\033[36m✅ sharkX404 profile loaded  •  ghelp = git shortcuts  •  clifuncs = all functions  •  Ctrl+R = fuzzy history\033[0m\n\n'
