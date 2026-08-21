# =====================================================================
# ⚙️  Core — Oh My Posh, eza, zsh options, history, plugins
# =====================================================================

# ── Oh My Posh — sharkX404 theme ─────────────────────────────────────
if command -v oh-my-posh &>/dev/null; then
    _omp_theme="${_PROFILE_DIR:-$(dirname "$(readlink ~/.zshrc 2>/dev/null || echo ~/.zshrc)")}/themes/sharkX404.omp.json"
    if [[ -f "$_omp_theme" ]]; then
        eval "$(oh-my-posh init zsh --config "$_omp_theme")"
    else
        eval "$(oh-my-posh init zsh)"
    fi
    unset _omp_theme
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
zstyle ':completion:*' menu yes select interactive   # arrow-key menu + interactive filter
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{cyan}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{yellow}  No matches for: %d%f'
zstyle ':completion:*' group-name ''
setopt MENU_COMPLETE     # Tab cycles through completions one by one

# ── fzf-tab (replaces default completion menu with fzf list) ──────────
# Install: brew install fzf-tab  OR  git clone to ~/.zsh/fzf-tab/
for _fzf_tab in \
    /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh \
    "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"; do
    if [[ -f "$_fzf_tab" ]]; then
        source "$_fzf_tab"
        # Preview file content when completing paths
        zstyle ':fzf-tab:complete:*' fzf-preview \
            '[[ -d $realpath ]] && eza --icons -1 $realpath || bat --color=always --line-range=:40 $realpath 2>/dev/null || cat $realpath 2>/dev/null'
        zstyle ':fzf-tab:*' fzf-flags --height=50% --border --reverse
        break
    fi
done
unset _fzf_tab

# ── zsh-autosuggestions ───────────────────────────────────────────────
for _plugin in \
    /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"; do
    [[ -f "$_plugin" ]] && { source "$_plugin"; break; }
done

# Use both history and completion as suggestion sources
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#606060'

# Key bindings for autosuggestions
bindkey '^ '   autosuggest-accept          # Ctrl+Space → accept full suggestion
bindkey '^[f'  forward-word                # Alt+F      → accept one word
bindkey '^['   autosuggest-clear           # Escape     → dismiss suggestion

# ── zsh-syntax-highlighting ───────────────────────────────────────────
# Must load AFTER all bindkey calls
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
