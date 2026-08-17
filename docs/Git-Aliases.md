# Git Command Aliases & Developer Shortcuts

This repository provides an extensive, non-breaking, developer-friendly Git shortcut library.

## Quick Reference Command
Run `ghelp` or `git-aliases` in your shell to print an interactive, colorized list of all available Git shortcuts.

## Summary Table

| Alias | Command / Description | Category |
| :--- | :--- | :--- |
| `gs` | `git status` | Basic |
| `gc` | `git commit` | Basic |
| `gp` | `git push` | Basic |
| `gpf` | `git push --force-with-lease` | Push |
| `gpl` | `git pull` | Basic |
| `gplr` | `git pull --rebase` | Pull |
| `gf` | `git fetch --all --prune` | Fetch |
| `gll` | `git log --oneline -n 15` | Log |
| `glog` | Interactive graph log | Log |
| `gco` | `git checkout` | Branch |
| `gcb` | `git checkout -b` | Branch |
| `gb` | `git branch` | Branch |
| `gba` | `git branch -a` | Branch |
| `gbd` | `git branch -d` | Branch |
| `gbD` | `git branch -D` | Branch |
| `gst` | `git stash` | Stash |
| `gstp` | `git stash pop` | Stash |
| `gstl` | `git stash list` | Stash |
| `gd` | `git diff` | Diff |
| `gds` | `git diff --staged` | Diff |
| `ga` | `git add` | Staging |
| `gaa` | `git add --all` | Staging |
| `gundo` | Undo last commit keeping changes staged | Safety |
| `greset` | Hard reset current branch (`git reset --hard`) | Reset |
| `gclean` | Interactive git clean (`git clean -fd`) | Cleanup |
| `gprune` | Delete local branches merged into master/main | Branch Cleanup |

## Detailed Workflow Usage

### 1. Staging & Committing
```powershell
gaa                    # Add all modified & untracked files
gc -m "feat: new app"  # Quick commit
gundo                  # Undo commit if you forgot a file (keeps changes staged)
```

### 2. Branch Management & Cleanup
```powershell
gcb feature/login      # Create & switch to feature branch
ghelp                  # View all Git aliases with suggestion hints
gprune                 # Delete obsolete merged local branches cleanly
```

### 3. Log & Diff Inspection
```powershell
gll                    # Clean 15-line git log
glog                   # Colorized commit graph visualization
gd                     # View unstaged changes
gds                    # View staged changes
```
