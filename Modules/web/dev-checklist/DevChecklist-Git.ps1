# Save this in your PowerShell profile ($PROFILE)
# Example: notepad $PROFILE
# Then paste this function and save

function DevChecklist-Git {
    param (
        [switch]$Full   # Show full details if needed
    )

    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "                   GIT CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan

    # ----------------- General / Help -----------------
    Write-Host "`n[General / Help]" -ForegroundColor Yellow
    Write-Host @"
git                         # Show Git commands
git help
git help <command>
git --version
"@

    # ----------------- Repository Setup -----------------
    Write-Host "`n[Repository Setup]" -ForegroundColor Yellow
    Write-Host @"
git init                    # Initialize new repo
git clone <repo-url>         # Clone remote repo
git clone <repo-url> <folder-name>  # Clone to folder
"@

    # ----------------- Status / Info -----------------
    Write-Host "`n[Status / Info]" -ForegroundColor Yellow
    Write-Host @"
git status                   # Show staged/unstaged files
git log                      # Full commit history
git log --oneline            # Short log
git log --graph --all --decorate
git show <commit>
git diff                     # Unstaged changes
git diff --staged            # Staged changes
"@

    # ----------------- Staging / Committing -----------------
    Write-Host "`n[Staging / Committing]" -ForegroundColor Yellow
    Write-Host @"
git add .                    # Stage all changes
git add <file>               # Stage specific file
git add -A                   # Stage all tracked/untracked
git reset <file>             # Unstage file
git commit -m 'message'
git commit -am 'message'     # Stage & commit tracked files
git commit --amend           # Amend last commit
"@

    # ----------------- Branching -----------------
    Write-Host "`n[Branching]" -ForegroundColor Yellow
    Write-Host @"
git branch                   # List branches
git branch <branch-name>     # Create branch
git branch -d <branch-name>  # Delete branch (safe)
git branch -D <branch-name>  # Delete branch (force)
git checkout <branch-name>   # Switch branch
git checkout -b <branch-name> # Create & switch
git switch <branch-name>     # Switch branch
git switch -c <branch-name>  # Create & switch
"@

    # ----------------- Merging / Rebasing -----------------
    Write-Host "`n[Merging / Rebasing]" -ForegroundColor Yellow
    Write-Host @"
git merge <branch>           # Merge branch into current
git merge --no-ff             # Merge without fast-forward
git rebase <branch>           # Rebase onto branch
git rebase -i HEAD~3          # Interactive rebase last 3 commits
git rebase --abort            # Abort rebase
git rebase --continue         # Continue after conflict
"@

    # ----------------- Remote Repositories -----------------
    Write-Host "`n[Remote Repositories]" -ForegroundColor Yellow
    Write-Host @"
git remote -v                # Show remotes
git remote add origin <url>  # Add remote
git remote remove origin
git remote rename origin upstream
git fetch
git pull origin main
git push
git push origin main
git push -u origin main       # Set upstream
"@

    # ----------------- Undo / Fix Mistakes -----------------
    Write-Host "`n[Undo / Fix Mistakes]" -ForegroundColor Yellow
    Write-Host @"
git restore <file>            # Undo changes
git restore --staged <file>   # Unstage
git reset --soft HEAD~1       # Undo last commit, keep changes
git reset --mixed HEAD~1      # Undo last commit, unstage
git reset --hard HEAD~1       # Undo last commit completely
git revert <commit-hash>      # Revert commit safely
"@

    # ----------------- Stash / Temporary Save -----------------
    Write-Host "`n[Stash / Temporary Save]" -ForegroundColor Yellow
    Write-Host @"
git stash                     # Save uncommitted changes
git stash list
git stash pop                 # Apply & remove from stash
git stash apply               # Apply without removing
git stash drop <stash>        # Delete stash
git stash clear               # Delete all stashes
"@

    # ----------------- Tags -----------------
    Write-Host "`n[Tags]" -ForegroundColor Yellow
    Write-Host @"
git tag                       # List tags
git tag v1.0.0                 # Create tag
git tag -a v1.0.0 -m 'release'
git push --tags                # Push tags to remote
"@

    # ----------------- Search / Debug -----------------
    Write-Host "`n[Search / Debug]" -ForegroundColor Yellow
    Write-Host @"
git blame <file>              # Show line authorship
git grep 'text'               # Search in repo
git bisect start
git bisect bad
git bisect good <commit>
"@

    # ----------------- Advanced / Power -----------------
    if ($Full) {
        Write-Host "`n[Advanced / Power User]" -ForegroundColor Yellow
        Write-Host @"
git cherry-pick <commit>
git reflog                     # Recover lost commits
git clean -fd                  # Remove untracked files
git archive                    # Export repo snapshot
git help -a                    # Show all Git commands
git log --oneline --graph --decorate --all
"@
    }

    Write-Host "`n=============================================" -ForegroundColor Cyan
    Write-Host "                  END OF GIT CHEAT SHEET" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
}
