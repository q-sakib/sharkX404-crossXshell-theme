# =====================================================================
# ⚙️  Core — Oh My Posh, eza, zsh options, history, plugins
# =====================================================================

# ── eza wrappers (replaces ls) ────────────────────────────────────────
if command -v eza &>/dev/null; then
    alias ls='eza --icons --git --color=auto'
    alias ll='eza --icons --git --color=auto -l'
    alias la='eza --icons --git --color=auto -a'
    alias lla='eza --icons --git --color=auto -la'
else
    alias ll='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
fi

# ── Zsh history ───────────────────────────────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# ── Zsh completion (compinit and autocomplete dropdown handled in .zshrc) ─
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{cyan}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{yellow}  No matches for: %d%f'
zstyle ':completion:*' group-name ''

# ── zsh-syntax-highlighting ───────────────────────────────────────────
# Must load AFTER compinit and AFTER all other plugins
for _plugin in \
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; do
    [[ -f "$_plugin" ]] && { source "$_plugin"; break; }
done
unset _plugin

# ── posh-git equivalent — git info in prompt via Oh My Posh ──────────
# (Oh My Posh handles git status natively — no extra setup needed)

# ── z / zoxide (jump to dirs) ─────────────────────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
elif command -v z &>/dev/null; then
    : # z is already sourced if installed as a shell function
fi

# ── Restore last directory across sessions ────────────────────────────
_last_dir_file="$HOME/.shark_last_dir"

_restore_last_location() {
    [[ -f "$_last_dir_file" ]] && {
        local dir
        dir=$(cat "$_last_dir_file")
        [[ -d "$dir" ]] && cd "$dir"
    }
}
_restore_last_location

_save_last_location() { echo "$PWD" > "$_last_dir_file"; }
autoload -Uz add-zsh-hook
add-zsh-hook zshexit _save_last_location

# ── Key bindings ──────────────────────────────────────────────────────
# Up/Down and Tab handled by zsh-autocomplete (shows live list)
# Tab in the list → select entry   Right/End → accept inline suggestion
bindkey "^[l"  clear-screen             # Alt+L = clear

# ── Misc aliases ──────────────────────────────────────────────────────
alias reload='source ~/.zshrc'
alias cls='clear'
