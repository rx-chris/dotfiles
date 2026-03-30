#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

echo "==> Zsh setup"

install_if_missing zsh git curl

ZSH_PATH="$(which zsh)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

# Check if already default
[[ "$CURRENT_SHELL" == "$ZSH_PATH" ]] && {
  echo "✅ zsh is already your default shell"
  exit 0
}

# Try chsh
chsh -s "$ZSH_PATH" 2>/dev/null && {
  echo "✅ Default shell changed to zsh via chsh"
  echo "🔄 Please restart your terminal for the change to take effect"
  exit 0
}

echo "⚠️ chsh failed, trying /etc/passwd..."

# Try editing /etc/passwd
[[ -w /etc/passwd ]] || {
  echo "❌ No permission to edit /etc/passwd"
  exit 1
}

sed -i "s|^\($USER:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\).*|\1$ZSH_PATH|" /etc/passwd && {
  echo "✅ /etc/passwd updated successfully"
  echo "🔄 Please restart your terminal for the change to take effect"
  exit 0
}

echo "❌ Failed to update /etc/passwd"
exit 1
