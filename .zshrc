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

# ── 0a. Oh My Posh — init FIRST so its zle-line-init hook is registered ──
# zsh-autocomplete (step 0b) uses add-zle-hook-widget to WRAP this hook.
# If OMP loads after autocomplete it overwrites autocomplete's hooks instead.
if command -v oh-my-posh &>/dev/null; then
    _omp_theme="$_PROFILE_DIR/themes/clean-detailed.omp.json"
    if [[ -f "$_omp_theme" ]]; then
        eval "$(oh-my-posh init zsh --config "$_omp_theme")"
    else
        eval "$(oh-my-posh init zsh)"
    fi
    unset _omp_theme
fi

# ── 0b. Completion system ─────────────────────────────────────────────
# compinit must run before any plugin that hooks into the completion system.
# (Previously handled internally by zsh-autocomplete; now explicit.)
autoload -Uz compinit && compinit

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

# ── 3. Run startup simulation (respects ~/.shark_prefs) ───────────────
[[ -f "$HOME/.shark_prefs" ]] && source "$HOME/.shark_prefs"
if [[ "${SHARK_SIMULATION:-1}" != "0" ]]; then
    _sim="$_PROFILE_DIR/simulation/shark/shark-session.zsh"
    [[ -f "$_sim" ]] && source "$_sim" && run-startup-welcome
    unset _sim
fi

# ── 4. Welcome line ───────────────────────────────────────────────────
printf '\n\033[36m✅ sharkX404 profile loaded  •  ghelp = git shortcuts  •  clifuncs = all functions  •  Ctrl+R = fuzzy history\033[0m\n\n'
