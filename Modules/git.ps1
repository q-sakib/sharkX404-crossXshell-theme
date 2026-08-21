# =====================================================================
# 🌿 Git Developer Shortcuts & Helper Functions
# Core aliases preserved + productivity extras & interactive viewer
# =====================================================================

# ── 1. Core Aliases ──
function gs  { git status }
function gc  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git commit @args }
function gp  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git push @args }
function gll { git log --oneline -n 15 }

# ── 2. Staging & Commit ──
function ga  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git add @args }
function gaa { git add --all }
function gundo {
    Write-Host "↩️ Undoing last commit (staged changes preserved)..." -ForegroundColor Yellow
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
    Deletes local branches that have already been merged into main/master.
    #>
    Write-Host "🧹 Pruning merged local branches..." -ForegroundColor Cyan
    $target = if (git show-ref --verify --quiet refs/heads/main 2>$null; $LASTEXITCODE -eq 0) { "main" } else { "master" }
    git checkout $target
    git pull
    git branch --merged | Where-Object { $_ -notmatch "^\*|\b(master|main|dev|development)\b" } | ForEach-Object {
        $b = $_.Trim()
        if ($b) {
            git branch -d $b
            Write-Host "  Deleted: $b" -ForegroundColor Green
        }
    }
}

# ── 4. Remote & Sync ──
function gf   { git fetch --all --prune }
function gpl  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git pull @args }
function gplr { git pull --rebase }
function gpf  { git push --force-with-lease }

# ── 5. Diff & Log ──
function gd   { param([Parameter(ValueFromRemainingArguments=$true)]$args) git diff @args }
function gds  { git diff --staged }
function glog { git log --graph --oneline --decorate --all -n 20 }

# ── 6. Stash ──
function gst  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git stash @args }
function gstp { git stash pop }
function gstl { git stash list }

# ── 7. Reset & Clean ──
function greset {
    Write-Host "⚠️ Hard resetting working tree to HEAD..." -ForegroundColor Red
    git reset --hard
}
function gclean {
    Write-Host "🧹 Cleaning untracked files & directories..." -ForegroundColor Yellow
    git clean -fd
}

# ── 8. Alias Reference Viewer ──
function git-aliases {
    <#
    .SYNOPSIS
    Displays all available Git shortcuts with descriptions.
    #>
    Write-Host "`n🌿 Git Shortcuts Reference:" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    $table = @(
        @{ Alias = "gs";     Cmd = "git status";                  Desc = "View repository status" },
        @{ Alias = "ga";     Cmd = "git add <files>";             Desc = "Stage specific files" },
        @{ Alias = "gaa";    Cmd = "git add --all";               Desc = "Stage all modified & untracked files" },
        @{ Alias = "gc";     Cmd = "git commit -m '...'";         Desc = "Commit staged changes" },
        @{ Alias = "gundo";  Cmd = "git reset --soft HEAD~1";     Desc = "Undo last commit (keeps staged)" },
        @{ Alias = "gp";     Cmd = "git push";                    Desc = "Push commits to remote" },
        @{ Alias = "gpf";    Cmd = "git push --force-with-lease"; Desc = "Safe force push" },
        @{ Alias = "gpl";    Cmd = "git pull";                    Desc = "Pull latest from remote" },
        @{ Alias = "gplr";   Cmd = "git pull --rebase";           Desc = "Pull and rebase local commits" },
        @{ Alias = "gf";     Cmd = "git fetch --all --prune";     Desc = "Fetch remotes, prune deleted branches" },
        @{ Alias = "gll";    Cmd = "git log --oneline -n 15";     Desc = "Clean 15-line commit log" },
        @{ Alias = "glog";   Cmd = "git log --graph --all";       Desc = "Colorized visual branch graph" },
        @{ Alias = "gco";    Cmd = "git checkout <branch>";       Desc = "Switch branch or restore file" },
        @{ Alias = "gcb";    Cmd = "git checkout -b <branch>";    Desc = "Create and switch to new branch" },
        @{ Alias = "gb";     Cmd = "git branch";                  Desc = "List local branches" },
        @{ Alias = "gba";    Cmd = "git branch -a";               Desc = "List all local & remote branches" },
        @{ Alias = "gbd";    Cmd = "git branch -d <branch>";      Desc = "Delete local branch safely" },
        @{ Alias = "gbD";    Cmd = "git branch -D <branch>";      Desc = "Force-delete local branch" },
        @{ Alias = "gprune"; Cmd = "(smart prune)";               Desc = "Delete branches merged into main/master" },
        @{ Alias = "gd";     Cmd = "git diff";                    Desc = "View unstaged changes" },
        @{ Alias = "gds";    Cmd = "git diff --staged";           Desc = "View staged changes" },
        @{ Alias = "gst";    Cmd = "git stash";                   Desc = "Stash uncommitted changes" },
        @{ Alias = "gstp";   Cmd = "git stash pop";               Desc = "Pop latest stash" },
        @{ Alias = "gstl";   Cmd = "git stash list";              Desc = "List all stashes" },
        @{ Alias = "greset"; Cmd = "git reset --hard";            Desc = "Hard reset to HEAD" },
        @{ Alias = "gclean"; Cmd = "git clean -fd";               Desc = "Remove untracked files & dirs" }
    )
    foreach ($row in $table) {
        Write-Host "  → " -NoNewline -ForegroundColor Green
        Write-Host ($row.Alias).PadRight(8)  -NoNewline -ForegroundColor Yellow
        Write-Host ($row.Cmd).PadRight(33)   -NoNewline -ForegroundColor White
        Write-Host "# $($row.Desc)"                     -ForegroundColor DarkGray
    }
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  💡 Run 'ghelp' any time to see this list again." -ForegroundColor Gray
}

function ghelp { git-aliases }
