# =====================================================================
# 📜 Fuzzy History & Deletion Layer (Zsh)
# Ctrl+R fuzzy search & interactive multiselect history deletion
# =====================================================================

export HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# Ctrl+R Fuzzy Search Handler
if command -v fzf >/dev/null 2>&1; then
    fzf-history-widget() {
        LBUFFER=$(fc -l -n 1 | fzf --height=80% --reverse --border --prompt='🔍 Command history > ' --info=inline)
        zle reset-prompt
    }
    zle -N fzf-history-widget
    bindkey '^R' fzf-history-widget
fi

# Interactive History Deletion (deletehistory)
deletehistory() {
    local target_file="${HISTFILE:-$HOME/.zsh_history}"
    if [[ ! -f "$target_file" ]]; then
        echo "❌ History file not found: $target_file"
        return 1
    fi
    if ! command -v fzf >/dev/null 2>&1; then
        echo "❌ 'fzf' is required for interactive history deletion."
        return 1
    fi

    local selected
    selected=$(cat "$target_file" | fzf --multi --height=80% --reverse --border \
        --prompt='🗑 Select Zsh history to delete > ' \
        --header='(Use TAB to mark multiple items, ENTER to confirm selection)')

    if [[ -z "$selected" ]]; then
        echo "ℹ️ No entries selected for deletion."
        return 0
    fi

    local count=$(echo "$selected" | wc -l | tr -d ' ')
    echo ""
    echo "⚠️ You are about to delete $count command(s) from $target_file."
    read "confirm?Type DELETE to confirm: "

    if [[ "$confirm" == "DELETE" ]]; then
        # Remove selected lines safely
        grep -vFf <(echo "$selected") "$target_file" > "${target_file}.tmp" && mv "${target_file}.tmp" "$target_file"
        echo "✅ Deleted $count item(s) from history."
        fc -R # Reload history in current session
    else
        echo "❌ Deletion canceled."
    fi
}

clean-history() {
    local target_file="${HISTFILE:-$HOME/.zsh_history}"
    if [[ -f "$target_file" ]]; then
        awk '!seen[$0]++' "$target_file" > "${target_file}.tmp" && mv "${target_file}.tmp" "$target_file"
        fc -R
        echo "✅ Zsh history deduplicated and cleaned."
    fi
}

alias delete-history="deletehistory"
