#!/bin/bash
set -e

KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY" ]; then
  ssh-keygen -t ed25519 -C "bitbucket" -f "$KEY" -N ""
fi

eval "$(ssh-agent -s)"
ssh-add "$KEY"

echo "📋 Copy this SSH key to Bitbucket:"
cat "$KEY.pub"

echo ""
echo "Bitbucket → Personal settings → SSH keys → Add key"