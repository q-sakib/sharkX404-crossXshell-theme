#!/bin/bash
set -e

# Load .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env not found!"
  exit 1
fi

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

# Optional: first clone using token (saves token in Keychain)
# Uncomment and edit workspace/repo
# git clone https://$BB_USER:$BB_TOKEN@bitbucket.org/<workspace>/<repo>.git