#!/usr/bin/env zsh
set -e

echo "🚀 Starting Ultimate AI + Fullstack Dev Terminal Bootstrap..."

# ------------------------------
# Helpers
# ------------------------------
info() { echo "\033[1;34m[INFO]\033[0m $1"; }
ok()   { echo "\033[1;32m[OK]\033[0m $1"; }

# ------------------------------
# Homebrew
# ------------------------------
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ok "Homebrew installed"
fi

# ------------------------------
# CLI Tools & Packages
# ------------------------------
info "Installing dev & AI tools..."

# brew install \
#   starship \
#   fzf \
#   eza \
#   bat \
#   ripgrep \
#   fd \
#   zoxide \
#   jq \
#   gh \
#   delta \
#   zsh-autosuggestions \
#   zsh-syntax-highlighting \
#   nvm \
#   pyenv \
#   direnv \
#   docker \
#   docker-compose \
#   postgresql \
#   mysql \
#   redis \
#   llm \
#   ghq \
#   lazygit \
#   tldr \
#   tree

#   openai \
#   terraform \
#   kubectl \
#   minikube \
#   hug-cli \

brew install \
  starship \
  fzf \
  eza \
  bat \
  ripgrep \
  fd \
  zoxide \
  jq \
  gh \
  delta \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  nvm \
  pyenv \
  direnv \
  docker \
  docker-compose \
  terraform \
  kubectl \
  minikube \
  postgresql \
  mysql \
  redis \
  lazygit \
  tldr \
  tree \
  pipx


ok "All packages installed under Homebrew"

pipx ensurepath
pipx install openai
pipx install huggingface_hub
pipx install llm

ok "All packages installed under Homebrew and pipx"


# ------------------------------
# Create ~/.zshrc
# ------------------------------
info "Creating ~/.zshrc"

cat > ~/.zshrc <<'EOF'
# ==============================
# ZSH FULL-STACK + AI TERMINAL
# ==============================

# ---- ZSH Plugins (safe loading) ----
ZSH_AUTOSUGGESTIONS="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_SYNTAX_HIGHLIGHTING="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[[ -f $ZSH_AUTOSUGGESTIONS ]] && source $ZSH_AUTOSUGGESTIONS
[[ -f $ZSH_SYNTAX_HIGHLIGHTING ]] && source $ZSH_SYNTAX_HIGHLIGHTING


# ---- Starship ----
eval "$(starship init zsh)"

# ---- FZF ----
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--preview 'bat --style=numbers --color=always {} 2>/dev/null'
"

# ---- zoxide ----
eval "$(zoxide init zsh)"
alias cd="z"

# ---- Node (nvm) ----
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

# ---- Python (pyenv) ----
eval "$(pyenv init -)"

# ---- direnv ----
eval "$(direnv hook zsh)"

# ---- Aliases ----
alias ls="eza --icons"
alias ll="eza -lah --git --icons"
alias tree="eza --tree --icons"

alias cat="bat"
alias grep="rg"
alias find="fd"

# Git
alias g="git"
alias gs="git status -sb"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias glg="lazygit"

# Docker
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dcu="docker-compose up"
alias dcd="docker-compose down"

# Node
alias ni="npm install"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"

# Python
alias py="python3"
alias venv="python3 -m venv .venv && source .venv/bin/activate"

# AI / ML CLI
alias hf="huggingface-cli"
alias openai="openai"
alias llm="llm"

# System / Utils
alias ports="lsof -i -P | grep LISTEN"
alias killport="fuser -k"
alias tldr="tldr"
alias cls="clear"

# ---- Keybindings ----
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- AI Helper Functions ----
ai() {
  if [[ -z "$1" ]]; then
    echo "Usage: ai \"your prompt here\""
    return 1
  fi
  openai chat completions create -m gpt-4 -t "$1" --stream | tee >(bat --paging=never -l txt)
  touch ~/.ai_last_command
}

summarize() {
  if [[ -z "$1" ]]; then
    echo "Usage: summarize <file>"
    return 1
  fi
  ai "Summarize the contents of $(basename "$1") < $(cat "$1")"
}

explain() {
  if [[ -z "$1" ]]; then
    echo "Usage: explain <file>"
    return 1
  fi
  ai "Explain this code in plain English: < $(cat "$1")"
}

gcm() {
  if [[ -z "$1" ]]; then
    echo "Usage: gcm <description>"
    return 1
  fi
  ai "Suggest a concise git commit message for: $1"
}

suggest() {
  if [[ -z "$1" ]]; then
    echo "Usage: suggest \"task description\""
    return 1
  fi
  ai "Write a code snippet for: $1"
}

# ---- Interactive FZF AI Menu ----
ai-fzf() {
  prompt_list=("Explain code" "Summarize file" "Suggest snippet" "Commit message")
  selection=$(printf "%s\n" "${prompt_list[@]}" | fzf --prompt="AI Command> ")
  case $selection in
    "Explain code") read -r file; explain "$file" ;;
    "Summarize file") read -r file; summarize "$file" ;;
    "Suggest snippet") read -r desc; suggest "$desc" ;;
    "Commit message") read -r desc; gcm "$desc" ;;
  esac
}
alias /ai-fzf="ai-fzf"
EOF

ok "~/.zshrc created"

# ------------------------------
# Starship config
# ------------------------------
info "Creating Starship config"

mkdir -p ~/.config

cat > ~/.config/starship.toml <<'EOF'
add_newline = true
command_timeout = 800

format = """
$username\
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$docker_context\
$cmd_duration\
$battery\
$memory_usage\
$time\
$custom.ai\
$character
"""

[username]
show_always = true
style_user = "bold cyan"
format = "[$user]($style) "

[directory]
style = "bold blue"
truncation_length = 3
truncation_symbol = "…/"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[cmd_duration]
min_time = 500
format = "⏱ [$duration](yellow) "

[battery]
disabled = false

[memory_usage]
disabled = false
threshold = 75
style = "bold red"

[time]
disabled = false
format = "🕒 [$time](dimmed white)"

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "purple"
format = '([$all_status$ahead_behind]($style) )'

[nodejs]
symbol = "⬢ "
style = "bold green"

[python]
symbol = "🐍 "
style = "bold yellow"

[docker_context]
symbol = "🐳 "
style = "blue"

[custom.ai]
when = "test -f ~/.ai_last_command"
command = "echo '🤖'"
style = "bold magenta"
EOF

ok "Starship config created"

# ------------------------------
# Git delta config
# ------------------------------
info "Configuring git + delta"

git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.side-by-side true

ok "Git configured"

# ------------------------------
# Finish
# ------------------------------
echo ""
ok "Ultimate AI + Fullstack Terminal Bootstrap Complete 🎉"
echo "➡ Restart your Terminal or run: source ~/.zshrc"
