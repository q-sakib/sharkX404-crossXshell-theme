# sharkX404 CrossShell Theme — Zsh Edition

Modular cyberpunk developer terminal for macOS. Oh My Posh prompt, eza file listings,
PSReadLine-style history ListView, fzf fuzzy search, and 31 Git shortcuts out of the box.

> **Platform:** macOS (Apple Silicon + Intel) · zsh · Homebrew

---

## Install on a fresh machine

### Step 1 — Clone the repo

```zsh
git clone https://github.com/sharkX404/sharkX404-crossXshell-theme.git \
    ~/--devX404/admin-shell/sharkX404-crossXshell-theme

cd ~/--devX404/admin-shell/sharkX404-crossXshell-theme
git checkout native/zsh
```

### Step 2 — Install all dependencies

```zsh
./starter-installer.sh
```

Installs Homebrew (if missing), all CLI tools, zsh plugins, and global npm packages.
Prompts once at the end to optionally install a database (PostgreSQL / MySQL / MongoDB).

### Step 3 — Link the profile

```zsh
./setup-profile.sh
```

- Backs up any existing `~/.zshrc`
- Symlinks `~/.zshrc` → this repo's `.zshrc`
- Asks whether to show the startup simulation

### Step 4 — Reload

```zsh
source ~/.zshrc
# or just open a new terminal
```

---

## What gets installed

### CLI tools (Homebrew)

| Tool | Purpose |
|------|---------|
| `oh-my-posh` | Prompt theme engine |
| `eza` | `ls` replacement with icons and git status |
| `fzf` | Fuzzy finder — powers `Ctrl+R` history search |
| `fd` | Fast `find` replacement |
| `bat` | `cat` with syntax highlighting (aliased to `cat`) |
| `ripgrep` | Fast `grep` replacement (aliased to `grep`) |
| `jq` | JSON processor |
| `zoxide` | Smart `cd` that learns your directories |
| `gh` | GitHub CLI |
| `node` | Node.js runtime |
| `php` + `composer` | PHP + Composer |
| `tldr` | Simplified man pages |
| `httpie` | HTTP client (`http` command) |

### zsh plugins (Homebrew)

| Plugin | Purpose |
|--------|---------|
| `zsh-autosuggestions` | Inline grey command suggestions as you type |
| `zsh-syntax-highlighting` | Live command syntax colouring |
| `zsh-history-substring-search` | Up/Down filtered history fallback |

### Global npm packages

`live-server` · `nodemon` · `prettier` · `eslint` · `@angular/cli` · `vercel` · `firebase-tools` · `next`

---

## Key shortcuts

### History

| Input | Action |
|-------|--------|
| Type `npm` then `↓` | History ListView — up to 10 prefix-matched recent commands |
| `↑` / `↓` | Navigate the ListView; wraps back to typed text |
| `Ctrl+R` | fzf fuzzy popup over full history |
| `Ctrl+Up` | fzf popup pre-filtered by current input |

### Shell

| Shortcut / Command | Action |
|-------------------|--------|
| `Alt+L` | Clear screen |
| `reload` | `source ~/.zshrc` |
| `cls` | `clear` |

### Navigation

| Command | Action |
|---------|--------|
| `z <dir>` | Jump to a frecent directory (zoxide) |
| `ll` | `eza -l` with icons and git status |
| `la` | `eza -a` (show hidden files) |
| `lla` | `eza -la` |

### Help commands

| Command | Shows |
|---------|-------|
| `ghelp` | All 31 Git shortcuts |
| `clifuncs` | Every loaded function, grouped by category |
| `nghelp` | Angular CLI shortcuts |
| `arthelp` | Laravel Artisan shortcuts |
| `dbhelp` | PostgreSQL + MySQL shortcuts |
| `envcheck` | Which dev tools are installed / missing |
| `sysinfo` | Architecture, macOS version, shell info |

---

## Git shortcuts (sample)

```zsh
gs      # git status
ga .    # git add .
gc      # git commit (opens editor)
gp      # git push
gpl     # git pull
gco     # git checkout
gcb     # git checkout -b (new branch)
gll     # git log --oneline
gprune  # delete merged local branches
ghelp   # full reference
```

---

## Module overview

```
.zshrc                          ← entry point (symlinked to ~/.zshrc)
modules/
  icons.zsh                     ← Nerd Font detection + icon map
  platform.zsh                  ← Homebrew + Composer PATH, sysinfo
  core.zsh                      ← eza, history, plugins, zoxide, keybinds
  git.zsh                       ← 31 Git shortcuts
  fzf-history.zsh               ← history ListView, Ctrl+R, hgrep, hclear
  angular.zsh                   ← Angular CLI shortcuts (ngs, ngb, ngg…)
  laravel.zsh                   ← Artisan shortcuts (art, mkc, mkmig…)
  pkgmgr.zsh                    ← npm / yarn / pnpm / bun smart wrappers
  webdev.zsh                    ← create-react/next/vue, deploy-*
  devtest.zsh                   ← HTTP tools, port tools, JWT decode
  docker.zsh                    ← dc, dcu, dcd, dlog, dclean
  db.zsh                        ← PostgreSQL + MySQL shortcuts
  tools.zsh                     ← ff, myip, load-env, edit-env
  benchmark.zsh                 ← bench { } — time any command
  error-handling.zsh            ← try-run
  ai-tools.zsh                  ← copilot-auth, hf-login
  clifuncs.zsh                  ← clifuncs listing
simulation/
  shark/shark-session.zsh       ← startup shark swim + cyberpunk welcome
  chaos/                        ← matrix rain, chaos patterns, PSE phases
themes/
  clean-detailed.omp.json       ← Oh My Posh prompt theme
starter-installer.sh            ← full dependency installer  ← run FIRST
setup-profile.sh                ← profile linker + sim preference  ← run SECOND
```

---

## Startup simulation

The shark swim animation and cyberpunk welcome screen run on every new terminal.
`setup-profile.sh` asks whether to enable this. Toggle it anytime:

```zsh
# Disable
echo "SHARK_SIMULATION=0" > ~/.shark_prefs

# Enable
echo "SHARK_SIMULATION=1" > ~/.shark_prefs
```

Re-run `./setup-profile.sh` to get the interactive prompt again.

---

## Re-run / update

Both scripts are idempotent — safe to re-run on an existing setup:

```zsh
git pull                  # get latest changes
./starter-installer.sh    # skips already-installed tools
./setup-profile.sh        # re-links profile, asks sim preference again
```

---

## Uninstall

```zsh
rm ~/.zshrc         # removes the symlink
rm ~/.shark_prefs   # removes simulation preference

# Restore backup if needed:
mv ~/.zshrc.bak.<timestamp> ~/.zshrc
```

The Homebrew packages and npm globals installed by `starter-installer.sh` are not removed — uninstall those separately with `brew uninstall <tool>` or `npm uninstall -g <pkg>` as needed.
