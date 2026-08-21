# =====================================================================
# ⚙️  Core — Oh My Posh, eza, zsh options, history, plugins
# =====================================================================

# ── Oh My Posh ────────────────────────────────────────────────────────
if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh)"
fi

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

# ── Zsh completion ────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ── zsh-autosuggestions ───────────────────────────────────────────────
for _plugin in \
    /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
    [[ -f "$_plugin" ]] && { source "$_plugin"; break; }
done

# ── zsh-syntax-highlighting ───────────────────────────────────────────
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

# ── Useful key bindings ───────────────────────────────────────────────
bindkey "^[[A" history-search-backward   # Up = history prefix search
bindkey "^[[B" history-search-forward    # Down = history prefix search
bindkey "^[l"  clear-screen             # Alt+L = clear

# ── Misc aliases ──────────────────────────────────────────────────────
alias reload='source ~/.zshrc'
alias cls='clear'
