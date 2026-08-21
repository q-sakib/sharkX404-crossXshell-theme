# =====================================================================
# 🔍 fzf — Fuzzy history (Ctrl+R), autosave, deletehistory
# =====================================================================

if command -v fzf &>/dev/null; then
    # Source fzf shell integration (Homebrew path first, then fallback)
    for _fzf_path in \
        /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
        /usr/local/opt/fzf/shell/key-bindings.zsh \
        "$HOME/.fzf.zsh"; do
        [[ -f "$_fzf_path" ]] && { source "$_fzf_path"; break; }
    done
    unset _fzf_path

    export FZF_DEFAULT_OPTS='--height=40% --reverse --border'
    export FZF_CTRL_R_OPTS='--preview="echo {}" --preview-window=down:3:hidden --bind="?:toggle-preview"'
fi

# Write history immediately on each command (equivalent to PSReadLine autosave)
autoload -Uz add-zsh-hook
add-zsh-hook precmd _shark_flush_history
_shark_flush_history() { fc -W 2>/dev/null; }

# Delete history entries by pattern
deletehistory() {
    local pattern=${1:-}
    if [[ -z "$pattern" ]]; then
        printf "${C_YELLOW}Usage: deletehistory <pattern>${C_RESET}\n"; return 1
    fi
    local hist_file="${HISTFILE:-$HOME/.zsh_history}"
    if [[ ! -f "$hist_file" ]]; then
        printf "${C_YELLOW}⚠️  History file not found: %s${C_RESET}\n" "$hist_file"; return 1
    fi
    # Remove matching lines (handles extended zsh history format ': timestamp:elapsed;cmd')
    sed -i '' "/$(printf '%s' "$pattern" | sed 's/[\/&]/\\&/g')/d" "$hist_file"
    fc -R "$hist_file"
    printf "${C_GREEN}✅ Deleted history entries matching: %s${C_RESET}\n" "$pattern"
}
