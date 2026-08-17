#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ZSHRC="$HOME/.zshrc"
SOURCE_ZSHRC="$SCRIPT_DIR/zshrc"

echo "⚡ Linking native Zsh profile..."

if [ -f "$TARGET_ZSHRC" ] || [ -L "$TARGET_ZSHRC" ]; then
    rm -f "$TARGET_ZSHRC"
fi

ln -sf "$SOURCE_ZSHRC" "$TARGET_ZSHRC"

echo "🔗 Symlinked: $TARGET_ZSHRC ➔ $SOURCE_ZSHRC"
echo "✅ Native Zsh setup complete! Run 'source ~/.zshrc' to activate."
