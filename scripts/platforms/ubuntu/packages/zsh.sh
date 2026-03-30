#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/install_if_missing.sh"

echo "==> Zsh setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  install_if_missing zsh git curl
}

# -------------------------------------------------
# configure phase (runs AFTER stow)
# -------------------------------------------------
configure() {
  ZSH_PATH="$(command -v zsh)"
  CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7 || true)"
 
  if [[ "$CURRENT_SHELL" == "$ZSH_PATH" ]]; then
    echo "✅ zsh is already your default shell"
    return 0
  fi

  if chsh -s "$ZSH_PATH" 2>/dev/null; then
    echo "✅ Default shell changed to zsh via chsh"
    echo "🔄 Restart terminal to apply changes"
    return 0
  fi

  echo "⚠️ chsh failed, trying /etc/passwd..."

  if [[ ! -w /etc/passwd ]]; then
    echo "❌ No permission to edit /etc/passwd"
    return 1
  fi

  if sed -i "s|^\($USER:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\).*|\1$ZSH_PATH|" /etc/passwd; then
    echo "✅ /etc/passwd updated successfully"
    echo "🔄 Restart terminal to apply changes"
    return 0
  fi

  echo "❌ Failed to update /etc/passwd"
  return 1
}

# -------------------------------------------------
# Entrypoint (only runs when executed directly)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
  configure
fi
