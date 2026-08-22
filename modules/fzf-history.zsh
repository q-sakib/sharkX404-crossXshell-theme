# =====================================================================
# 🔍 fzf — History search, interactive delete, autosave
# Ctrl+R = fzf search  |  Up (with text) = filtered list  |  hclear = multi-delete
# =====================================================================

if command -v fzf &>/dev/null; then
    for _fzf_path in \
        /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
        /usr/local/opt/fzf/shell/key-bindings.zsh \
        "$HOME/.fzf.zsh"; do
        [[ -f "$_fzf_path" ]] && { source "$_fzf_path"; break; }
    done
    unset _fzf_path

    export FZF_DEFAULT_OPTS='--height=50% --reverse --border --info=inline'
    export FZF_CTRL_R_OPTS='
        --preview="echo {}"
        --preview-window=down:3:hidden
        --bind="?:toggle-preview"
        --header="Ctrl+R: history  |  ?: toggle preview  |  Enter: execute"
    '
fi

# ── Per-command history flush (equivalent to PSReadLine autosave) ─────
autoload -Uz add-zsh-hook
add-zsh-hook precmd _shark_flush_history
_shark_flush_history() { fc -W 2>/dev/null; }

# ── Ctrl+Up — fzf fuzzy history popup (broader search than Up/Down) ──
# Up/Down is now handled by zsh-history-substring-search (core.zsh)
# Ctrl+Up opens fzf with any matching entry from full history
_shark_fzf_history_popup() {
    local query="$BUFFER"
    local selected
    selected=$(fc -l 1 | grep -F "$query" | fzf --tac --no-sort \
        --height=50% --reverse --border \
        --query="$query" \
        --prompt='↑ History > ' \
        --header="Matching entries for: $query" \
        --no-multi)
    if [[ -n "$selected" ]]; then
        BUFFER="${selected##*[0-9] }"
        BUFFER="${BUFFER# }"
        CURSOR=${#BUFFER}
        zle reset-prompt
    fi
}
zle -N _shark_fzf_history_popup
bindkey '^[[1;5A' _shark_fzf_history_popup   # Ctrl+Up — fzf popup

# ── hgrep — search history with fzf, puts result in readline buffer ──
hgrep() {
    if ! command -v fzf &>/dev/null; then
        fc -l 1 | grep "${1:-.}"
        return
    fi
    local query=${1:-}
    local selected
    selected=$(fc -l 1 | fzf --tac --no-sort \
        --height=60% --reverse --border \
        --prompt='🔍 History > ' \
        --header='ENTER = send to buffer  |  ESC = cancel  |  ?: preview' \
        --query="$query" \
        --preview='echo {}' \
        --preview-window=down:3:hidden \
        --bind='?:toggle-preview' \
        --no-multi)
    if [[ -n "$selected" ]]; then
        local cmd="${selected##*[0-9] }"
        cmd="${cmd# }"
        print -z "$cmd"     # inject into Zsh readline buffer without executing
    fi
}

# ── hclear — fzf multi-select interactive delete ──────────────────────
# TAB = mark multiple  |  ENTER = delete marked  |  ESC = cancel
hclear() {
    if ! command -v fzf &>/dev/null; then
        printf "${C_YELLOW}fzf required. Use: deletehistory <pattern>${C_RESET}\n"; return 1
    fi
    local hist_file="${HISTFILE:-$HOME/.zsh_history}"
    [[ ! -f "$hist_file" ]] && { printf "${C_YELLOW}History file not found.${C_RESET}\n"; return 1; }

    local selected
    selected=$(fc -l 1 | fzf --multi --tac --no-sort \
        --height=65% --reverse --border \
        --prompt='🗑 Select to delete > ' \
        --header='TAB = mark  |  ENTER = delete selected  |  ESC = cancel' \
        --preview='echo {}' \
        --preview-window=down:2:hidden \
        --bind='?:toggle-preview')

    if [[ -z "$selected" ]]; then
        printf "${C_GRAY}  Nothing selected — no entries deleted.${C_RESET}\n"; return
    fi

    local count=0
    while IFS= read -r entry; do
        local cmd="${entry##*[0-9] }"
        cmd="${cmd# }"
        [[ -z "$cmd" ]] && continue
        local escaped
        escaped=$(printf '%s' "$cmd" | sed 's/[]\/$*.^[]/\\&/g')
        sed -i '' "/$escaped/d" "$hist_file" 2>/dev/null
        (( count++ )) || true
    done <<< "$selected"

    fc -R "$hist_file"
    printf "${C_GREEN}✅ Deleted %d history entry/entries.${C_RESET}\n" "$count"
}

# ── deletehistory — delete by pattern (non-interactive) ───────────────
deletehistory() {
    local pattern=${1:-}
    if [[ -z "$pattern" ]]; then
        printf "${C_YELLOW}Usage: deletehistory <pattern>${C_RESET}\n"
        printf "${C_GRAY}  Tip: hclear  = fzf multi-select interactive delete\n"
        printf "       hgrep   = fuzzy search history${C_RESET}\n"
        return 1
    fi
    local hist_file="${HISTFILE:-$HOME/.zsh_history}"
    [[ ! -f "$hist_file" ]] && { printf "${C_YELLOW}⚠️  History file not found.${C_RESET}\n"; return 1; }

    local before after
    before=$(wc -l < "$hist_file" | tr -d ' ')
    local escaped
    escaped=$(printf '%s' "$pattern" | sed 's/[]\/$*.^[]/\\&/g')
    sed -i '' "/$escaped/d" "$hist_file"
    after=$(wc -l < "$hist_file" | tr -d ' ')
    fc -R "$hist_file"
    printf "${C_GREEN}✅ Removed %d line(s) matching: %s${C_RESET}\n" "$(( before - after ))" "$pattern"
}

# ── hdup — show duplicate history entries (useful before hclear) ──────
hdup() {
    printf "${C_CYAN}Duplicate history entries:${C_RESET}\n"
    fc -l 1 | awk '{$1=""; sub(/^ /, ""); print}' | sort | uniq -dc | sort -rn | head -30
}
