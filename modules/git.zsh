# =====================================================================
# 🌿 Git Developer Shortcuts & Helper Functions
# Full parity with the PowerShell git.ps1 library.
# =====================================================================

# ── Shared confirmation helper ────────────────────────────────────────
_confirm_git_action() {
    printf "\n${C_RED}⚠️  %s${C_RESET}\n" "$1"
    printf "   Proceed? [y/N] "
    read -r _git_answer
    [[ "$_git_answer" =~ ^[Yy]$ ]]
}

# ── 1. Core ───────────────────────────────────────────────────────────
gs()  { git status }
gc()  { git commit "$@" }
gp()  { git push "$@" }
gll() { git log --oneline -n 15 }

# ── 2. Staging & Commit ───────────────────────────────────────────────
ga()  { git add "$@" }
gaa() { git add --all }

gundo() {
    printf "${C_YELLOW}↩️  Undoing last commit (staged changes preserved)...${C_RESET}\n"
    git reset --soft HEAD~1
}

# ── 3. Branch Management ──────────────────────────────────────────────
gco() { git checkout "$@" }
gcb() { git checkout -b "$1" }
gb()  { git branch }
gba() { git branch -a }

gbd() {
    local branch=$1
    if [[ -z "$branch" ]]; then
        printf "${C_YELLOW}Usage: gbd <branch-name>${C_RESET}\n"; return 1
    fi
    _confirm_git_action "Delete LOCAL branch '$branch' (git branch -d). Remote is NOT affected." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git branch -d "$branch"
}

gbD() {
    local branch=$1
    if [[ -z "$branch" ]]; then
        printf "${C_YELLOW}Usage: gbD <branch-name>${C_RESET}\n"; return 1
    fi
    _confirm_git_action "Force-delete LOCAL branch '$branch' (git branch -D). Remote is NOT affected." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git branch -D "$branch"
}

gprune() {
    git show-ref --verify --quiet refs/heads/main 2>/dev/null
    local target=$([[ $? -eq 0 ]] && echo "main" || echo "master")

    local candidates
    candidates=$(git branch --merged | grep -vE "^\*|\b(master|main|dev|development)\b" | sed 's/^[[:space:]]*//' | grep -v '^$')

    if [[ -z "$candidates" ]]; then
        printf "${C_GREEN}✅ No merged branches to prune.${C_RESET}\n"
        return
    fi

    if command -v fzf &>/dev/null; then
        local selected
        selected=$(echo "$candidates" | fzf --multi \
            --height=50% \
            --reverse \
            --border \
            --prompt='🧹 Branches to delete > ' \
            --header="TAB = mark  |  ENTER = delete selected  |  ESC = cancel  (LOCAL only)" \
            --preview='git log --oneline -8 {}' \
            --preview-window=right:50%)

        if [[ -z "$selected" ]]; then
            printf "${C_GRAY}ℹ️  Nothing selected — no branches deleted.${C_RESET}\n"
            return
        fi

        git checkout "$target" &>/dev/null
        git pull --quiet
        while IFS= read -r b; do
            git branch -d "$b"
            printf "${C_GREEN}  🗑 Deleted: %s${C_RESET}\n" "$b"
        done <<< "$selected"
    else
        printf "${C_YELLOW}⚠️  fzf not found — listing candidates only (install fzf for interactive mode).${C_RESET}\n"
        printf "${C_CYAN}\nMerged branches eligible for pruning:${C_RESET}\n"
        echo "$candidates" | while IFS= read -r b; do
            printf "${C_YELLOW}  • %s${C_RESET}\n" "$b"
        done
        printf "${C_GRAY}\nRun 'git branch -d <name>' to delete manually.${C_RESET}\n"
    fi
}

# ── 4. Remote & Sync ──────────────────────────────────────────────────
gf()   { git fetch --all --prune }
gpl()  { git pull "$@" }
gplr() { git pull --rebase }
gpf()  { git push --force-with-lease }

gpu() {
    local branch
    branch=$(git branch --show-current)
    if [[ -z "$branch" ]]; then
        printf "${C_YELLOW}⚠️  Not on a named branch.${C_RESET}\n"; return 1
    fi
    printf "${C_CYAN}🚀 Pushing '%s' → origin and setting upstream...${C_RESET}\n" "$branch"
    git push -u origin "$branch"
}

# ── 5. Diff & Log ─────────────────────────────────────────────────────
gd()   { git diff "$@" }
gds()  { git diff --staged }
glog() { git log --graph --oneline --decorate --all -n 20 }

# ── 6. Stash ──────────────────────────────────────────────────────────
gst()  { git stash "$@" }
gstp() { git stash pop }
gstl() { git stash list }

# ── 7. Reset & Clean (all destructive — require confirmation) ─────────
greset() {
    _confirm_git_action "Hard reset to HEAD — all unstaged changes will be lost." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git reset --hard
}

grremote() {
    local branch remote ahead
    branch=$(git branch --show-current)
    if [[ -z "$branch" ]]; then
        printf "${C_YELLOW}⚠️  Not on a named branch.${C_RESET}\n"; return 1
    fi

    remote="origin/$branch"
    git show-ref --verify --quiet "refs/remotes/$remote" 2>/dev/null
    if [[ $? -ne 0 ]]; then
        printf "${C_YELLOW}⚠️  Remote tracking branch '%s' not found. Run 'gf' first.${C_RESET}\n" "$remote"
        return 1
    fi

    ahead=$(git rev-list --count "$remote..HEAD" 2>/dev/null | tr -d '[:space:]')
    printf "  Current branch : ${C_WHITE}%s${C_RESET}\n" "$branch"
    printf "  Remote         : ${C_WHITE}%s${C_RESET}\n" "$remote"
    if [[ "$ahead" -gt 0 ]]; then
        printf "  Local commits ahead of remote: ${C_YELLOW}%s${C_RESET}\n" "$ahead"
    else
        printf "  Local commits ahead of remote: ${C_GRAY}%s${C_RESET}\n" "$ahead"
    fi

    _confirm_git_action "Reset '$branch' to '$remote' — $ahead local commit(s) will be discarded." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git reset --hard "$remote"
}

grc() {
    local commit=${1:-}
    local mode=${2:-soft}

    if [[ -z "$commit" ]]; then
        printf "${C_YELLOW}Usage: grc <commit> [soft|mixed|hard]${C_RESET}\n"; return 1
    fi
    case $mode in
        soft|mixed|hard) ;;
        *)
            printf "${C_RED}Invalid mode: %s (use soft, mixed, or hard)${C_RESET}\n" "$mode"
            return 1
            ;;
    esac

    local info
    info=$(git log --oneline -1 "$commit" 2>/dev/null)
    if [[ -z "$info" ]]; then
        printf "${C_YELLOW}⚠️  Commit '%s' not found.${C_RESET}\n" "$commit"; return 1
    fi

    printf "  Target commit  : ${C_WHITE}%s${C_RESET}\n" "$info"
    case $mode in
        soft)  printf "  Reset mode     : ${C_CYAN}--soft${C_RESET}\n" ;;
        mixed) printf "  Reset mode     : ${C_YELLOW}--mixed${C_RESET}\n" ;;
        hard)  printf "  Reset mode     : ${C_RED}--hard${C_RESET}\n" ;;
    esac

    local consequence
    case $mode in
        soft)  consequence="Commits after $commit will be undone; changes remain staged." ;;
        mixed) consequence="Commits after $commit will be undone; changes become unstaged." ;;
        hard)  consequence="Commits AND working-tree changes after $commit will be permanently lost." ;;
    esac

    _confirm_git_action "$consequence" || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git reset --$mode "$commit"
}

gclean() {
    printf "${C_YELLOW}  Untracked files that will be removed:${C_RESET}\n"
    git clean -nd
    _confirm_git_action "Delete all untracked files and directories shown above." || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git clean -fd
}

# ── 8. Cherry-pick ────────────────────────────────────────────────────
gcp() {
    if [[ $# -eq 0 ]]; then
        printf "${C_YELLOW}Usage: gcp <hash> [hash...]${C_RESET}\n"; return 1
    fi
    local current_branch
    current_branch=$(git branch --show-current)
    printf "${C_CYAN}🍒 Cherry-picking %d commit(s) onto %s:${C_RESET}\n" "$#" "$current_branch"
    for c in "$@"; do
        local info
        info=$(git log --oneline -1 "$c" 2>/dev/null)
        printf "  ${C_WHITE}%s${C_RESET}\n" "$info"
    done
    git cherry-pick "$@"
}

# ── 9. Revert ─────────────────────────────────────────────────────────
grev() {
    local commit=${1:-}
    if [[ -z "$commit" ]]; then
        printf "${C_YELLOW}Usage: grev <hash>${C_RESET}\n"; return 1
    fi

    local info
    info=$(git log --oneline -1 "$commit" 2>/dev/null)
    if [[ -z "$info" ]]; then
        printf "${C_YELLOW}⚠️  Commit '%s' not found.${C_RESET}\n" "$commit"; return 1
    fi

    printf "  Target commit  : ${C_WHITE}%s${C_RESET}\n" "$info"
    printf "  ${C_CYAN}A new revert-commit will be created. History is NOT rewritten.${C_RESET}\n"

    _confirm_git_action "Revert commit $commit ? (A new 'Revert ...' commit will be added.)" || {
        printf "${C_GRAY}  Cancelled.${C_RESET}\n"; return
    }
    git revert "$commit"
}

# ── 10. Alias Reference Viewer ────────────────────────────────────────
git-aliases() {
    printf "\n${C_CYAN}🌿 Git Shortcuts Reference:${C_RESET}\n"
    printf "  ${C_GRAY}─────────────────────────────────────────────────────────────${C_RESET}\n"

    local rows=(
        "gs|git status|Repository status"
        "ga|git add <files>|Stage files"
        "gaa|git add --all|Stage everything"
        "gc|git commit|Commit staged changes"
        "gundo|git reset --soft HEAD~1|Undo last commit (keeps staged)"
        "gp|git push|Push commits to remote"
        "gpu|git push -u origin <branch>|Push & set upstream for current branch"
        "gpf|git push --force-with-lease|Safe force push"
        "gpl|git pull|Pull latest from remote"
        "gplr|git pull --rebase|Pull and rebase"
        "gf|git fetch --all --prune|Fetch & prune stale remotes"
        "gll|git log --oneline -n 15|Clean 15-line log"
        "glog|git log --graph --all|Visual branch graph"
        "gco|git checkout|Switch branch / restore file"
        "gcb|git checkout -b <branch>|Create & switch branch"
        "gb|git branch|List local branches"
        "gba|git branch -a|List all branches (local + remote)"
        "gbd|git branch -d  [y/N]|Delete LOCAL branch (safe, merge-checked)"
        "gbD|git branch -D  [y/N]|Force-delete LOCAL branch"
        "gprune|(fzf multi-select)|Delete merged LOCAL branches interactively"
        "gd|git diff|Unstaged changes"
        "gds|git diff --staged|Staged changes"
        "gst|git stash|Stash changes"
        "gstp|git stash pop|Pop stash"
        "gstl|git stash list|List stashes"
        "gcp|git cherry-pick <hash…>|Cherry-pick one or more commits"
        "grev|git revert  [y/N]|Revert commit safely (new undo-commit)"
        "greset|git reset --hard  [y/N]|Hard reset to HEAD (loses unstaged changes)"
        "grremote|origin/<branch>  [y/N]|Reset hard to remote HEAD"
        "grc|git reset <hash>  [y/N]|Reset to any commit (soft/mixed/hard)"
        "gclean|git clean -fd  [y/N]|Remove all untracked files & dirs"
    )

    for row in "${rows[@]}"; do
        local alias_name cmd desc
        alias_name="${row%%|*}"
        rest="${row#*|}"
        cmd="${rest%%|*}"
        desc="${rest#*|}"
        printf "  ${C_GREEN}→ ${C_YELLOW}%-11s${C_WHITE}%-35s${C_GRAY}# %s${C_RESET}\n" \
            "$alias_name" "$cmd" "$desc"
    done

    printf "  ${C_GRAY}─────────────────────────────────────────────────────────────${C_RESET}\n"
    printf "  ${C_YELLOW}⚠️  [y/N] = prompts before executing destructive operations.${C_RESET}\n"
    printf "  ${C_CYAN}🔒 Branch deletes (gbd/gbD/gprune) are LOCAL only — remote is never touched.${C_RESET}\n"
    printf "  ${C_GRAY}💡 Run 'ghelp' any time to see this list again.${C_RESET}\n"
}
alias ghelp='git-aliases'
