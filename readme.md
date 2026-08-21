# ⚡ sharkX404 CrossShell Theme

> A cross-platform, modular PowerShell developer environment with cyberpunk terminal animations, a 26-function Git shortcut library, web-framework scaffolding tools, fuzzy history search, and resilient icon rendering — targeting Windows 11 and macOS.

---

## Features

| Category | What you get |
|---|---|
| **Prompt** | Oh My Posh (`easy-term` theme) with graceful fallback |
| **Icons** | Eza file listings with Nerd Font icons; ASCII fallback when fonts are unavailable |
| **Git** | 26 shortcut functions + interactive `ghelp` reference viewer |
| **History** | Persistent fuzzy history search via `Ctrl+R` (fzf), safe multi-select deletion |
| **Web Dev** | Node, React, Next.js, Vue, Angular, Laravel, Express scaffolding |
| **API Testing** | `api`, `api-get`, `api-post` wrappers (httpie or `Invoke-RestMethod` fallback) |
| **Docker** | `dc`, `dcu`, `dcd`, `dlog`, `dclean` shortcuts |
| **AI Tools** | GitHub Copilot CLI + HuggingFace CLI authentication helpers |
| **Simulations** | Shark ASCII animation, randomised cyberpunk banners, chaos/matrix effects |
| **Platform** | Apple Silicon vs Intel detection, Homebrew PATH auto-injection on macOS |
| **Discovery** | `clifuncs` / `basefuncs` — list every loaded function at any time |
| **Installer** | One-shot `starter-installer.ps1` bootstraps the entire toolchain |

---

## Requirements

| Platform | Minimum version |
|---|---|
| **Windows** | Windows 11 · PowerShell 7.0+ |
| **macOS** | macOS 12+ · PowerShell 7.0+ · Homebrew |

```powershell
# Enable script execution (Windows, one-time)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Installation

### Windows

```powershell
# 1. Clone the repository
git clone https://github.com/sharkX404/sharkX404-crossXshell-theme.git
cd sharkX404-crossXshell-theme

# 2. Install all tools (winget, npm globals, PowerShell modules)
.\starter-installer.ps1

# 3A. Copy the profile
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# 3B. Or symlink it (keeps profile in sync with the repo)
New-Item -ItemType SymbolicLink -Path $PROFILE `
         -Target (Resolve-Path .\Microsoft.PowerShell_profile.ps1) -Force
```

> Run as **Administrator** for the first-time install or when creating symlinks.

### macOS

```bash
# 1. Clone
git clone https://github.com/sharkX404/sharkX404-crossXshell-theme.git
cd sharkX404-crossXshell-theme

# 2. Install PowerShell 7
brew install powershell/tap/powershell

# 3. Install required tools
brew install oh-my-posh eza fzf fd bat ripgrep

# 4. Symlink the profile
mkdir -p ~/.config/powershell
ln -sf "$(pwd)/Microsoft.PowerShell_profile.ps1" \
       ~/.config/powershell/Microsoft.PowerShell_profile.ps1
```

> Install a [Nerd Font](https://www.nerdfonts.com/) (e.g. **JetBrainsMono Nerd Font**) and configure it in your terminal for full icon support.

### What `starter-installer.ps1` installs (Windows)

```
gh · fzf · tldr · httpie · eza · oh-my-posh
nvm · Node.js LTS · live-server · nodemon · prettier · eslint
next · @angular/cli · @githubnext/copilot-cli · vercel · firebase-tools · heroku
php · composer · laravel installer
Docker Desktop
PSReadLine · posh-git · z  (PowerShell modules)
PostgreSQL | MySQL | MongoDB  (your choice, optional)
```

---

## Quick Start

```powershell
# Open a new PowerShell session — the shark animation plays on startup.

ghelp          # Full Git shortcut reference
clifuncs       # Every custom function currently loaded
basefuncs      # Core utility functions in a table
sysinfo        # OS, chip architecture, PowerShell version

Ctrl+R         # Fuzzy-search command history (fzf)
deletehistory  # Multi-select history entries to permanently remove
```

---

## Navigation

```powershell
up   # Set-Location ..
..   # Set-Location ..
...  # Set-Location ../..
z    # Smart directory jump (requires the 'z' module)
```

---

## Git Shortcuts

Run `ghelp` at any time to print the full reference. Summary:

| Alias | Command | Description |
|---|---|---|
| `gs` | `git status` | Repository status |
| `ga` | `git add <files>` | Stage files |
| `gaa` | `git add --all` | Stage everything |
| `gc` | `git commit` | Commit (pass `-m`, `--amend`, etc.) |
| `gundo` | `git reset --soft HEAD~1` | Undo last commit, keep staged |
| `gp` | `git push` | Push to remote |
| `gpf` | `git push --force-with-lease` | Safe force push |
| `gpl` | `git pull` | Pull from remote |
| `gplr` | `git pull --rebase` | Pull + rebase |
| `gf` | `git fetch --all --prune` | Fetch & prune stale remotes |
| `gll` | `git log --oneline -n 15` | Clean 15-line log |
| `glog` | `git log --graph --all` | Visual branch graph |
| `gco` | `git checkout` | Switch branch / restore file |
| `gcb <name>` | `git checkout -b <name>` | Create & switch branch |
| `gb` | `git branch` | List local branches |
| `gba` | `git branch -a` | List all branches |
| `gbd <name>` | `git branch -d <name>` | Delete branch safely |
| `gbD <name>` | `git branch -D <name>` | Force-delete branch |
| `gprune` | *(smart)* | Delete all merged local branches |
| `gd` | `git diff` | Unstaged changes |
| `gds` | `git diff --staged` | Staged changes |
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop latest stash |
| `gstl` | `git stash list` | List stashes |
| `greset` | `git reset --hard` | Hard reset to HEAD |
| `gclean` | `git clean -fd` | Remove untracked files |

---

## Web Development

### Scaffolding

```powershell
create-react MyApp       # npx create-react-app
create-next  MyApp       # npx create-next-app@latest
create-vue   MyApp       # npm create vue@latest
ngnew        MyApp       # ng new (Angular CLI)
laravelnew   my-project  # laravel new
nodenew      my-api      # Node.js + Express scaffold with index.js
```

### Dev servers

```powershell
live          # npx live-server  (static HTML/CSS/JS)
dev           # nodemon index.js  (pass a filename to override: dev app.js)
codehere      # code .  (open VS Code in current directory)
```

### Deploy

```powershell
deploy-vercel    # vercel --prod
deploy-firebase  # firebase deploy
deploy-heroku    # git push heroku main
```

### Laravel Artisan shortcuts

```powershell
art serve                   # php artisan serve
art-make-model User         # php artisan make:model
art-make-model-full Post    # make:model -mcrsf (full scaffold)
art-make-controller UserController
art-migrate                 # php artisan migrate
art-migrate-rollback
art-dbseed
```

### API Testing

```powershell
api GET  https://api.example.com/users
api POST https://api.example.com/users '{"name":"test"}'
api-get  https://jsonplaceholder.typicode.com/posts/1
api-post https://api.example.com/posts @{title="x"; body="y"; userId=1}
```

### Utilities

```powershell
jsonpretty '{"a":1}'   # Pretty-print a JSON string
load-env               # Load .env into the current session
edit-env               # Open .env in VS Code
ff  <pattern>          # fd (fast file finder)
grep <pattern>         # rg (ripgrep)
preview <file>         # bat (syntax-highlighted cat)
myip                   # Public IP info (ipinfo.io)
bench { Get-Date }     # Time any script block
```

### Docker

```powershell
dc   <args>   # docker compose
dcu           # docker compose up -d
dcd           # docker compose down
dlog <name>   # docker logs -f <container>
dclean        # docker system prune -a -f
```

---

## Terminal Simulations

The shark animation + SHARK banner runs automatically on every session start. All simulations can also be dot-sourced manually:

```powershell
# Shark swim + SHARK welcome banner (runs on startup)
. .\Modules\simulation\shark\shark-session.ps1

# Random name banner animation (SAKIB / SHARK / DENZI / X404)
. .\Modules\simulation\shark\randomnymous.ps1

# Animated banner + colour-coded function-guide overlay
. .\Modules\simulation\shark\randomnymous2.ps1

# Random-character chaos lines
. .\Modules\simulation\chaos\chaos.ps1

# Chaos pattern with command-guide ASCII art
. .\Modules\simulation\chaos\chaospattern.ps1

# Matrix rain with mutating chars, ERROR flashes, countdown
# Press Ctrl+C to exit — runs in an infinite loop by design
. .\Modules\simulation\chaos\matrix.ps1

# Scripted boot sequence (BIOS check, DNA stream, intruder alert)
. .\Modules\simulation\chaos\PSE-Phase2.ps1

# AI core, filesystem takeover, interactive self-destruct (abort code: 1337)
. .\Modules\simulation\chaos\PSE-Phase3.ps1
```

---

## Platform & Icon Detection

```powershell
sysinfo    # OS, chip (Apple Silicon / Intel), Rosetta status, Homebrew prefix, PS version
mac-arch   # alias for sysinfo
```

Icon rendering is fully automatic:

- **Nerd Font detected** (Windows Terminal, iTerm2, WezTerm, kitty, ghostty, VS Code): full emoji/icon set  
- **No Nerd Font**: clean ASCII fallbacks (`[OK]`, `[!]`, `[X]`, …) — no broken glyphs

Eza detection is automatic at startup:

- **Eza installed**: `ls`, `ll`, `la` wrap `eza --icons --git`  
- **Eza missing**: `ls` falls back to `Get-ChildItem`, `ll`/`la` behave accordingly

---

## History Management

```powershell
Ctrl+R         # Fuzzy-search merged session + file history (last 100 unique)
deletehistory  # TAB to select entries, ENTER, type DELETE to confirm removal
```

History is saved:
- Automatically every **5 minutes** during the session
- On session **exit** (`Register-EngineEvent PowerShell.Exiting`)
- File: `$APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt`

---

## Dev Checklists

```powershell
DevChecklist             # General checklist
DevChecklist-Angular     # Angular pre-deploy checklist
DevChecklist-Laravel     # Laravel pre-deploy checklist
DevChecklist-Node        # Node.js pre-deploy checklist
DevChecklist-Database    # Database migration checklist
DevChecklist-Git         # Git hygiene checklist
DevChecklist-PowerShell  # PowerShell module health checklist
```

---

## Module Structure

```
sharkX404-crossXshell-theme/
├── Microsoft.PowerShell_profile.ps1   # Profile entry point
├── starter-installer.ps1              # One-shot toolchain bootstrapper
├── powershell.config.json             # Execution policy config
│
├── Modules/
│   ├── icons.ps1           # Nerd Font detection & icon resilience layer
│   ├── platform.ps1        # OS/chip detection, Homebrew PATH injection
│   ├── core.ps1            # PSReadLine, eza wrappers, navigation shortcuts
│   ├── git.ps1             # 26 Git shortcut functions + ghelp viewer
│   ├── fzf-history.ps1     # Fuzzy history (Ctrl+R), autosave, deletion
│   ├── tools.ps1           # ff, grep, preview, myip, load-env, edit-env
│   ├── ai-tools.ps1        # Copilot CLI & HuggingFace login helpers
│   ├── api-testing.ps1     # api, api-get, api-post wrappers
│   ├── docker.ps1          # Docker Compose shortcuts
│   ├── error-handling.ps1  # try-run helper
│   ├── benchmark.ps1       # bench { } execution timer
│   │
│   ├── web/
│   │   ├── webdev.ps1                  # Node, React, Next, Vue, Angular, Deploy
│   │   ├── scripts/laravel/            # Artisan helpers, auth, resources, testing
│   │   ├── scripts/node-js.ps1         # nodenew, nodemon helpers
│   │   ├── scripts/angular.ps1         # Angular shortcuts
│   │   ├── scripts/nextCLI.ps1         # Next.js CLI shortcuts
│   │   ├── scripts/db/ORM/mongoose/    # MongoDB model scaffolding
│   │   ├── scripts/db/ORM/prisma/      # Prisma model & CLI shortcuts
│   │   ├── scripts/db/ORM/eloquent/    # Eloquent seeder, factory, Tinker helpers
│   │   └── dev-checklist/              # Interactive pre-deployment checklists
│   │
│   └── simulation/
│       ├── shark/    # Shark animation, random banner, cyberpunk session
│       └── chaos/    # Chaos lines, matrix rain, PSE phase scripts
│
├── git-setup/
│   ├── setup.ps1        # Windows Git credential setup
│   ├── setup.sh         # macOS/Linux Git credential setup
│   └── environment.ts   # Shared environment config
│
└── python/
    ├── generate_ascii_lorenz.py   # Lorenz attractor ASCII art generator
    └── Lorenz_attractor_yb.svg    # Reference attractor image
```

---

## Branch Overview

| Branch | Purpose |
|---|---|
| `main` | Primary — Windows + macOS PowerShell |
| `dev-os/mac-master` | macOS cross-platform improvements (icons, platform detection, enhanced git) |
| `dev-native-os/mac-main` | Native Zsh layer for macOS (`native-shell/modules/*.zsh`) |
| `dev-os/windows-master` | Windows experiments (`f1/FullstackCLI` prototype, `db/` scripts) |

---

## Contributing

1. Fork and clone the repository
2. Create a branch: `git checkout -b feature/my-improvement`
3. Make changes — keep each module focused on a single concern
4. Open a fresh PowerShell session and run `clifuncs` to verify all functions load
5. Submit a pull request against `main`

**Conventions:**
- Use `Join-Path` for all file paths (cross-platform)
- Guard external commands: `Get-Command <tool> -ErrorAction SilentlyContinue`
- Use approved PowerShell verbs (`Get-`, `Set-`, `Invoke-`, …); expose short aliases for interactive use
- Add `.SYNOPSIS` to any function intended for `Get-Help`

---

## Troubleshooting

**Icons appear as boxes / question marks**  
Install a [Nerd Font](https://www.nerdfonts.com/) and set it in your terminal. Recommended: *JetBrainsMono Nerd Font* or *CaskaydiaCove Nerd Font*.

**`eza` not found**
```powershell
winget install eza-community.eza   # Windows
brew install eza                   # macOS
```

**`oh-my-posh` not found**
```powershell
winget install JanDeDobbeleer.OhMyPosh   # Windows
brew install oh-my-posh                  # macOS
```

**`Ctrl+R` not working**
```powershell
winget install fzf   # Windows
brew install fzf     # macOS
```

**Profile loads slowly**
```powershell
Measure-Command { . $PROFILE }
# First load includes posh-git and oh-my-posh init — subsequent loads are fast.
```

**Debug history file**
```powershell
$f = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
Get-Content $f | Measure-Object -Line
Get-Content $f | Select-Object -Last 10
```

---

## Maintainer

**sharkX404** · Sakib  
Cyberpunk-grade terminal. Stay sharp. Code sharper.
