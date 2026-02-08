#!/bin/bash
set -e

echo "🔧 Configuring Git (macOS)..."

# ---- User identity ----
git config --global user.name "Sakib SiddiQuie"
git config --global user.email "i.sak1uib@gmail.com"

# ---- Credential storage ----
git config --global credential.helper osxkeychain
git config --global credential.username "q-sakib"

# ---- Core settings ----
git config --global core.autocrlf input
git config --global core.fscache true
git config --global core.symlinks true
git config --global pull.rebase false
git config --global init.defaultBranch master

# ---- Editor ----
git config --global core.editor "code --wait"

# ---- Git LFS ----
if command -v git-lfs >/dev/null 2>&1; then
  git lfs install
else
  echo "⚠️  git-lfs not found. Install via: brew install git-lfs"
fi

echo ""
echo "✅ Git configuration complete."
echo "➡️  Now clone or pull a Bitbucket repo ONCE to save your app password."
