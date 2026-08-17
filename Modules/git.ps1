# =====================================================================
# 🌿 Expanded Git Developer Shortcuts & Helper Functions
# All original aliases preserved + productivity extras & suggestion guide
# =====================================================================

# ── 1. Original Core Aliases (Preserved) ──
function gs  { git status }
function gc  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git commit @args }
function gp  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git push @args }
function gll { git log --oneline -n 15 }

# ── 2. Staging & Commit Shortcuts ──
function ga  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git add @args }
function gaa { git add --all }
function gundo {
    Write-Host "↩️ Undoing last commit (preserving staged changes)..." -ForegroundColor Yellow
    git reset --soft HEAD~1
}

# ── 3. Branch Management ──
function gco { param([Parameter(ValueFromRemainingArguments=$true)]$args) git checkout @args }
function gcb { param([string]$branch) git checkout -b $branch }
function gb  { git branch }
function gba { git branch -a }
function gbd { param([string]$branch) git branch -d $branch }
function gbD { param([string]$branch) git branch -D $branch }

function gprune {
    <#
    .SYNOPSIS
    Prunes local branches that have already been merged into default branch.
    #>
    Write-Host "🧹 Pruning merged local branches..." -ForegroundColor Cyan
    $targetBranch = if (git show-ref --verify --quiet refs/heads/main) { "main" } else { "master" }
    git checkout $targetBranch
    git pull
    git branch --merged | Where-Object { $_ -notmatch "^\*|\b(master|main|dev|development)\b" } | ForEach-Object {
        $b = $_.Trim()
        if ($b) {
            git branch -d $b
            Write-Host "Deleted merged branch: $b" -ForegroundColor Green
        }
    }
}

# ── 4. Remote & Sync Operations ──
function gf   { git fetch --all --prune }
function gpl  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git pull @args }
function gplr { git pull --rebase }
function gpf  { git push --force-with-lease }

# ── 5. Diff & Log Helpers ──
function gd   { param([Parameter(ValueFromRemainingArguments=$true)]$args) git diff @args }
function gds  { git diff --staged }
function glog { git log --graph --oneline --decorate --all -n 20 }

# ── 6. Stash Helpers ──
function gst  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git stash @args }
function gstp { git stash pop }
function gstl { git stash list }

# ── 7. Reset & Clean ──
function greset {
    Write-Host "⚠️ Hard resetting working tree..." -ForegroundColor Red
    git reset --hard
}
function gclean {
    Write-Host "🧹 Cleaning untracked files & directories..." -ForegroundColor Yellow
    git clean -fd
}

# ── 8. Interactive Suggestion Viewer ──
function git-aliases {
    <#
    .SYNOPSIS
    Displays all available Git aliases with colorized descriptions & suggestions.
    #>
    Write-Host "`n🌿 Git Shortcuts & Suggestions Reference:" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    $aliases = @(
        @{ Alias = "gs";     Cmd = "git status";                   Desc = "View repository status" },
        @{ Alias = "ga";     Cmd = "git add <files>";              Desc = "Stage specific files" },
        @{ Alias = "gaa";    Cmd = "git add --all";                Desc = "Stage all modified & untracked files" },
        @{ Alias = "gc";     Cmd = "git commit -m '...'";          Desc = "Commit staged changes" },
        @{ Alias = "gundo";  Cmd = "git reset --soft HEAD~1";      Desc = "Undo last commit (keeps changes staged)" },
        @{ Alias = "gp";     Cmd = "git push";                     Desc = "Push commits to remote" },
        @{ Alias = "gpf";    Cmd = "git push --force-with-lease";  Desc = "Safe force push" },
        @{ Alias = "gpl";    Cmd = "git pull";                     Desc = "Pull latest changes from remote" },
        @{ Alias = "gplr";   Cmd = "git pull --rebase";            Desc = "Pull and rebase local commits" },
        @{ Alias = "gf";     Cmd = "git fetch --all --prune";      Desc = "Fetch remotes and prune deleted branches" },
        @{ Alias = "gll";    Cmd = "git log --oneline -n 15";      Desc = "Show clean 15-line commit log" },
        @{ Alias = "glog";   Cmd = "git log --graph --all";        Desc = "Colorized visual branch graph" },
        @{ Alias = "gco";    Cmd = "git checkout <branch>";        Desc = "Switch branch or restore file" },
        @{ Alias = "gcb";    Cmd = "git checkout -b <branch>";     Desc = "Create and switch to new branch" },
        @{ Alias = "gb";     Cmd = "git branch";                   Desc = "List local branches" },
        @{ Alias = "gba";    Cmd = "git branch -a";                Desc = "List all local & remote branches" },
        @{ Alias = "gbd";    Cmd = "git branch -d <branch>";       Desc = "Delete local branch safely" },
        @{ Alias = "gprune"; Cmd = "prune merged local branches";  Desc = "Delete branches merged into main/master" },
        @{ Alias = "gd";     Cmd = "git diff";                     Desc = "View unstaged changes" },
        @{ Alias = "gds";    Cmd = "git diff --staged";            Desc = "View staged changes" },
        @{ Alias = "gst";    Cmd = "git stash";                    Desc = "Stash uncommitted changes" },
        @{ Alias = "gstp";   Cmd = "git stash pop";                Desc = "Pop stashed changes" },
        @{ Alias = "gstl";   Cmd = "git stash list";               Desc = "List all stashes" }
    )

    foreach ($a in $aliases) {
        $formattedAlias = ($a.Alias).PadRight(8)
        $formattedCmd   = ($a.Cmd).PadRight(32)
        Write-Host "  → " -NoNewline -ForegroundColor Green
        Write-Host $formattedAlias -NoNewline -ForegroundColor Yellow
        Write-Host $formattedCmd -NoNewline -ForegroundColor White
        Write-Host "# $($a.Desc)" -ForegroundColor DarkGray
    }
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  💡 Tip: Type any alias to execute it instantly!" -ForegroundColor Gray
}

function ghelp { git-aliases }
Set-Alias ghelp git-aliases -ErrorAction SilentlyContinue
