# =====================================================================
# 🌿 Expanded Git Developer Shortcuts & Helper Functions (Zsh)
# =====================================================================

alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull"
alias gplr="git pull --rebase"
alias gf="git fetch --all --prune"
alias gll="git log --oneline -n 15"
alias glog="git log --graph --oneline --decorate --all -n 20"
alias ga="git add"
alias gaa="git add --all"
alias gco="git checkout"
alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gd="git diff"
alias gds="git diff --staged"
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias greset="git reset --hard"
alias gclean="git clean -fd"

gcb() {
    git checkout -b "$1"
}

gundo() {
    echo "↩️ Undoing last commit (preserving staged changes)..."
    git reset --soft HEAD~1
}

gprune() {
    echo "🧹 Pruning merged local branches..."
    local target="main"
    git show-ref --verify --quiet refs/heads/main || target="master"
    git checkout "$target" && git pull
    git branch --merged | grep -vE '^\*|master|main|dev' | xargs -n 1 git branch -d 2>/dev/null || true
}

git-aliases() {
    echo ""
    echo "🌿 Git Shortcuts & Suggestions Reference:"
    echo "  ─────────────────────────────────────────────────────────────"
    printf "  → %-8s %-32s # %s\n" "gs" "git status" "View repository status"
    printf "  → %-8s %-32s # %s\n" "ga" "git add <files>" "Stage specific files"
    printf "  → %-8s %-32s # %s\n" "gaa" "git add --all" "Stage all modified & untracked files"
    printf "  → %-8s %-32s # %s\n" "gc" "git commit -m '...'" "Commit staged changes"
    printf "  → %-8s %-32s # %s\n" "gundo" "git reset --soft HEAD~1" "Undo last commit (keeps changes staged)"
    printf "  → %-8s %-32s # %s\n" "gp" "git push" "Push commits to remote"
    printf "  → %-8s %-32s # %s\n" "gpf" "git push --force-with-lease" "Safe force push"
    printf "  → %-8s %-32s # %s\n" "gpl" "git pull" "Pull latest changes from remote"
    printf "  → %-8s %-32s # %s\n" "gplr" "git pull --rebase" "Pull and rebase local commits"
    printf "  → %-8s %-32s # %s\n" "gf" "git fetch --all --prune" "Fetch remotes and prune deleted branches"
    printf "  → %-8s %-32s # %s\n" "gll" "git log --oneline -n 15" "Show clean 15-line commit log"
    printf "  → %-8s %-32s # %s\n" "glog" "git log --graph --all" "Colorized visual branch graph"
    printf "  → %-8s %-32s # %s\n" "gco" "git checkout <branch>" "Switch branch or restore file"
    printf "  → %-8s %-32s # %s\n" "gcb" "git checkout -b <branch>" "Create and switch to new branch"
    printf "  → %-8s %-32s # %s\n" "gb" "git branch" "List local branches"
    printf "  → %-8s %-32s # %s\n" "gba" "git branch -a" "List all local & remote branches"
    printf "  → %-8s %-32s # %s\n" "gbd" "git branch -d <branch>" "Delete local branch safely"
    printf "  → %-8s %-32s # %s\n" "gprune" "prune merged local branches" "Delete branches merged into main/master"
    echo "  ─────────────────────────────────────────────────────────────"
    echo ""
}

ghelp() { git-aliases; }
alias ghelp="git-aliases"
