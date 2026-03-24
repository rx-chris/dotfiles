#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

echo "==> Rust setup"

# -------------------------------------------------
# Install dependencies
# -------------------------------------------------
install_if_missing curl build-essential

# -------------------------------------------------
# Install rustup (if not installed)
# -------------------------------------------------
if ! command -v rustup >/dev/null 2>&1; then
  echo "==> installing rustup"

  curl https://sh.rustup.rs -sSf | sh -s -- -y

  # load cargo env for current session
  source "$HOME/.cargo/env"
else
  echo "✔ rustup already installed"
fi

# -------------------------------------------------
# Ensure stable toolchain
# -------------------------------------------------
rustup default stable

echo "✔ Rust setup complete"
