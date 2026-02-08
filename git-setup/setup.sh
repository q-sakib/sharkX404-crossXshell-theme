#!/bin/bash
set -e

BB_USER="YOUR_BITBUCKET_USERNAME"
NAME="Sakib SiddiQuie"
EMAIL="i.sak1uib@gmail.com"

echo "🔧 Configuring Git (macOS/Linux)"

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
git config --global pull.rebase false
git config --global init.defaultBranch master
git config --global core.autocrlf input
git config --global core.editor "code --wait"

# Credential helper
git config --global credential.helper osxkeychain
git config --global credential.username "$BB_USER"

# Prefer HTTPS, fallback to SSH
git config --global url."https://bitbucket.org/".insteadOf git@bitbucket.org:

echo "✅ Git configured"
echo "➡️ Run ssh-setup.sh to enable SSH fallback"
echo "➡️ Clone/pull once to store token"
