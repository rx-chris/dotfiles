#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

echo "==> Neovim setup"

# -------------------------------------------------
# Install Neovim
# -------------------------------------------------
install_if_missing nvim

# -------------------------------------------------
# Optional dependencies (recommended tools)
# -------------------------------------------------
install_if_missing git curl unzip ripgrep

echo "✔ Neovim package setup complete"
