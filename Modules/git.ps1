# =====================================================================
# 🌿 Git Developer Shortcuts & Helper Functions
# Core aliases preserved + productivity extras & interactive viewer
# =====================================================================

# ── Shared confirmation helper ────────────────────────────────────────
function Confirm-GitAction {
    <#
    .SYNOPSIS
    Prints a destructive-action warning and prompts [y/N]. Returns $true if confirmed.
    #>
    param([string]$Message)
    Write-Host "`n⚠️  $Message" -ForegroundColor Red
    $answer = Read-Host "   Proceed? [y/N]"
    return ($answer -match '^[Yy]$')
}

# ── 1. Core Aliases ──────────────────────────────────────────────────
function gs  { git status }
function gc  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git commit @args }
function gp  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git push @args }
function gll { git log --oneline -n 15 }

# ── 2. Staging & Commit ──────────────────────────────────────────────
function ga  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git add @args }
function gaa { git add --all }

function gundo {
    Write-Host "↩️  Undoing last commit (staged changes preserved)..." -ForegroundColor Yellow
    git reset --soft HEAD~1
}

# ── 3. Branch Management ─────────────────────────────────────────────
function gco { param([Parameter(ValueFromRemainingArguments=$true)]$args) git checkout @args }
function gcb { param([string]$branch) git checkout -b $branch }
function gb  { git branch }
function gba { git branch -a }

function gbd {
    <#
    .SYNOPSIS
    Safely deletes a LOCAL branch (already-merged guard). Remote is not touched.
    #>
    param([string]$branch)
    if (-not $branch) { Write-Host "Usage: gbd <branch-name>" -ForegroundColor Yellow; return }
    if (-not (Confirm-GitAction "Delete LOCAL branch '$branch' (git branch -d). Remote is NOT affected.")) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git branch -d $branch
}

function gbD {
    <#
    .SYNOPSIS
    Force-deletes a LOCAL branch regardless of merge status. Remote is not touched.
    #>
    param([string]$branch)
    if (-not $branch) { Write-Host "Usage: gbD <branch-name>" -ForegroundColor Yellow; return }
    if (-not (Confirm-GitAction "Force-delete LOCAL branch '$branch' (git branch -D). Remote is NOT affected.")) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git branch -D $branch
}

function gprune {
    <#
    .SYNOPSIS
    Interactively selects merged local branches via fzf preview, then deletes confirmed ones.
    TAB = mark multiple  |  ENTER = delete  |  ESC = cancel.
    Falls back to listing candidates if fzf is not installed. Remote branches are NOT touched.
    #>
    git show-ref --verify --quiet refs/heads/main 2>$null
    $target = if ($LASTEXITCODE -eq 0) { "main" } else { "master" }

    $candidates = git branch --merged |
        Where-Object { $_ -notmatch "^\*|\b(master|main|dev|development)\b" } |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ }

    if (-not $candidates) {
        Write-Host "✅ No merged branches to prune." -ForegroundColor Green
        return
    }

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        $selected = $candidates | fzf --multi `
            --height=50% `
            --reverse `
            --border `
            --prompt='🧹 Branches to delete > ' `
            --header="TAB = mark  |  ENTER = delete selected  |  ESC = cancel  (LOCAL only)" `
            --preview='git log --oneline -8 {}' `
            --preview-window=right:50%

        if (-not $selected) {
            Write-Host "ℹ️  Nothing selected — no branches deleted." -ForegroundColor DarkGray
            return
        }

        git checkout $target | Out-Null
        git pull --quiet
        foreach ($b in $selected) {
            git branch -d $b
            Write-Host "  🗑 Deleted: $b" -ForegroundColor Green
        }
    } else {
        Write-Warning "fzf not found — listing candidates only (install fzf for interactive mode)."
        Write-Host "`nMerged branches eligible for pruning:" -ForegroundColor Cyan
        $candidates | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
        Write-Host "`nRun 'git branch -d <name>' to delete manually." -ForegroundColor DarkGray
    }
}

# ── 4. Remote & Sync ─────────────────────────────────────────────────
function gf   { git fetch --all --prune }
function gpl  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git pull @args }
function gplr { git pull --rebase }
function gpf  { git push --force-with-lease }

function gpu {
    <#
    .SYNOPSIS
    Pushes the current branch and sets origin as its upstream (-u).
    Use this the first time you push a new local branch to remote.
    #>
    $branch = git branch --show-current
    if (-not $branch) { Write-Warning "Not on a named branch."; return }
    Write-Host "🚀 Pushing '$branch' → origin and setting upstream..." -ForegroundColor Cyan
    git push -u origin $branch
}

# ── 5. Diff & Log ────────────────────────────────────────────────────
function gd   { param([Parameter(ValueFromRemainingArguments=$true)]$args) git diff @args }
function gds  { git diff --staged }
function glog { git log --graph --oneline --decorate --all -n 20 }

# ── 6. Stash ─────────────────────────────────────────────────────────
function gst  { param([Parameter(ValueFromRemainingArguments=$true)]$args) git stash @args }
function gstp { git stash pop }
function gstl { git stash list }

# ── 7. Reset & Clean (all destructive — require confirmation) ─────────

function greset {
    <#
    .SYNOPSIS
    Hard-resets the working tree to the last local commit (HEAD). Unstaged changes are lost.
    #>
    if (-not (Confirm-GitAction "Hard reset to HEAD — all unstaged changes will be lost.")) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git reset --hard
}

function grremote {
    <#
    .SYNOPSIS
    Hard-resets the current branch to match the remote (origin/<branch>).
    All local commits ahead of the remote will be lost.
    Fetch first with 'gf' if you want the latest remote state.
    #>
    $branch = git branch --show-current
    if (-not $branch) { Write-Warning "Not on a named branch."; return }

    $remote = "origin/$branch"
    git show-ref --verify --quiet "refs/remotes/$remote" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Remote tracking branch '$remote' not found. Run 'gf' first."
        return
    }

    $ahead = (git rev-list --count "$remote..HEAD" 2>$null).Trim()
    Write-Host "  Current branch : $branch" -ForegroundColor White
    Write-Host "  Remote         : $remote" -ForegroundColor White
    Write-Host "  Local commits ahead of remote: $ahead" -ForegroundColor $(if ($ahead -gt 0) { "Yellow" } else { "Gray" })

    if (-not (Confirm-GitAction "Reset '$branch' to '$remote' — $ahead local commit(s) will be discarded.")) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git reset --hard $remote
}

function grc {
    <#
    .SYNOPSIS
    Resets to a specific commit. Defaults to --soft (history rewritten, files kept staged).
    Pass -Mode hard to also discard working-tree changes.

    .EXAMPLE
    grc abc1234           # soft reset — commits gone, changes staged
    grc abc1234 -Mode mixed  # commits gone, changes unstaged
    grc abc1234 -Mode hard   # commits AND changes gone
    #>
    param(
        [Parameter(Mandatory=$true)][string]$Commit,
        [ValidateSet('soft', 'mixed', 'hard')][string]$Mode = 'soft'
    )

    $info = git log --oneline -1 $Commit 2>$null
    if (-not $info) { Write-Warning "Commit '$Commit' not found."; return }

    Write-Host "  Target commit  : $info" -ForegroundColor White
    Write-Host "  Reset mode     : --$Mode" -ForegroundColor $(
        switch ($Mode) { 'soft' { 'Cyan' } 'mixed' { 'Yellow' } 'hard' { 'Red' } }
    )

    $consequence = switch ($Mode) {
        'soft'  { "Commits after $Commit will be undone; changes remain staged." }
        'mixed' { "Commits after $Commit will be undone; changes become unstaged." }
        'hard'  { "Commits AND working-tree changes after $Commit will be permanently lost." }
    }

    if (-not (Confirm-GitAction $consequence)) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git reset --$Mode $Commit
}

function gclean {
    <#
    .SYNOPSIS
    Removes all untracked files and directories. Cannot be undone.
    #>
    Write-Host "  Untracked files that will be removed:" -ForegroundColor Yellow
    git clean -nd
    if (-not (Confirm-GitAction "Delete all untracked files and directories shown above.")) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git clean -fd
}

# ── 8. Cherry-pick ───────────────────────────────────────────────────
function gcp {
    <#
    .SYNOPSIS
    Cherry-picks one or more commits onto the current branch.

    .EXAMPLE
    gcp abc1234
    gcp abc1234 def5678   # picks both commits in order
    #>
    param([Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)][string[]]$Commits)

    Write-Host "🍒 Cherry-picking $($Commits.Count) commit(s) onto $(git branch --show-current):" -ForegroundColor Cyan
    foreach ($c in $Commits) {
        $info = git log --oneline -1 $c 2>$null
        Write-Host "  $info" -ForegroundColor White
    }
    git cherry-pick @Commits
}

# ── 9. Revert ────────────────────────────────────────────────────────
function grev {
    <#
    .SYNOPSIS
    Safely reverts a commit by creating a new undo-commit. The original commit remains in history.
    This is the safe alternative to resetting — it does not rewrite history.

    .EXAMPLE
    grev abc1234
    #>
    param([Parameter(Mandatory=$true)][string]$Commit)

    $info = git log --oneline -1 $Commit 2>$null
    if (-not $info) { Write-Warning "Commit '$Commit' not found."; return }

    Write-Host "  Target commit  : $info" -ForegroundColor White
    Write-Host "  A new revert-commit will be created. History is NOT rewritten." -ForegroundColor Cyan

    if (-not (Confirm-GitAction "Revert commit $Commit ? (A new 'Revert ...' commit will be added.)")) {
        Write-Host "  Cancelled." -ForegroundColor DarkGray; return
    }
    git revert $Commit
}

# ── 10. Alias Reference Viewer ────────────────────────────────────────
function git-aliases {
    <#
    .SYNOPSIS
    Displays all available Git shortcuts with descriptions.
    #>
    Write-Host "`n🌿 Git Shortcuts Reference:" -ForegroundColor Cyan
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    $table = @(
        @{ Alias = "gs";        Cmd = "git status";                  Desc = "Repository status" },
        @{ Alias = "ga";        Cmd = "git add <files>";             Desc = "Stage files" },
        @{ Alias = "gaa";       Cmd = "git add --all";               Desc = "Stage everything" },
        @{ Alias = "gc";        Cmd = "git commit";                  Desc = "Commit staged changes" },
        @{ Alias = "gundo";     Cmd = "git reset --soft HEAD~1";     Desc = "Undo last commit (keeps staged)" },
        @{ Alias = "gp";        Cmd = "git push";                    Desc = "Push commits to remote" },
        @{ Alias = "gpu";       Cmd = "git push -u origin <branch>"; Desc = "Push & set upstream for current branch" },
        @{ Alias = "gpf";       Cmd = "git push --force-with-lease"; Desc = "Safe force push" },
        @{ Alias = "gpl";       Cmd = "git pull";                    Desc = "Pull latest from remote" },
        @{ Alias = "gplr";      Cmd = "git pull --rebase";           Desc = "Pull and rebase" },
        @{ Alias = "gf";        Cmd = "git fetch --all --prune";     Desc = "Fetch & prune stale remotes" },
        @{ Alias = "gll";       Cmd = "git log --oneline -n 15";     Desc = "Clean 15-line log" },
        @{ Alias = "glog";      Cmd = "git log --graph --all";       Desc = "Visual branch graph" },
        @{ Alias = "gco";       Cmd = "git checkout";                Desc = "Switch branch / restore file" },
        @{ Alias = "gcb";       Cmd = "git checkout -b <branch>";    Desc = "Create & switch branch" },
        @{ Alias = "gb";        Cmd = "git branch";                  Desc = "List local branches" },
        @{ Alias = "gba";       Cmd = "git branch -a";               Desc = "List all branches (local + remote)" },
        @{ Alias = "gbd";       Cmd = "git branch -d  [y/N]";        Desc = "Delete LOCAL branch (safe, merge-checked)" },
        @{ Alias = "gbD";       Cmd = "git branch -D  [y/N]";        Desc = "Force-delete LOCAL branch" },
        @{ Alias = "gprune";    Cmd = "(fzf multi-select)";          Desc = "Delete merged LOCAL branches interactively" },
        @{ Alias = "gd";        Cmd = "git diff";                    Desc = "Unstaged changes" },
        @{ Alias = "gds";       Cmd = "git diff --staged";           Desc = "Staged changes" },
        @{ Alias = "gst";       Cmd = "git stash";                   Desc = "Stash changes" },
        @{ Alias = "gstp";      Cmd = "git stash pop";               Desc = "Pop stash" },
        @{ Alias = "gstl";      Cmd = "git stash list";              Desc = "List stashes" },
        @{ Alias = "gcp";       Cmd = "git cherry-pick <hash…>";     Desc = "Cherry-pick one or more commits" },
        @{ Alias = "grev";      Cmd = "git revert  [y/N]";           Desc = "Revert commit safely (new undo-commit)" },
        @{ Alias = "greset";    Cmd = "git reset --hard  [y/N]";     Desc = "Hard reset to HEAD (loses unstaged changes)" },
        @{ Alias = "grremote";  Cmd = "origin/<branch>  [y/N]";      Desc = "Reset hard to remote HEAD" },
        @{ Alias = "grc";       Cmd = "git reset <hash>  [y/N]";     Desc = "Reset to any commit (soft/mixed/hard)" },
        @{ Alias = "gclean";    Cmd = "git clean -fd  [y/N]";        Desc = "Remove all untracked files & dirs" }
    )
    foreach ($row in $table) {
        Write-Host "  → " -NoNewline -ForegroundColor Green
        Write-Host ($row.Alias).PadRight(11) -NoNewline -ForegroundColor Yellow
        Write-Host ($row.Cmd).PadRight(35)   -NoNewline -ForegroundColor White
        Write-Host "# $($row.Desc)"           -ForegroundColor DarkGray
    }
    Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  ⚠️  [y/N] = prompts before executing destructive operations." -ForegroundColor Yellow
    Write-Host "  🔒 Branch deletes (gbd/gbD/gprune) are LOCAL only — remote is never touched." -ForegroundColor Cyan
    Write-Host "  💡 Run 'ghelp' any time to see this list again." -ForegroundColor Gray
}

function ghelp { git-aliases }
