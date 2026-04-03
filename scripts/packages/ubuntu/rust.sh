#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load utilities & libraries
# -------------------------------------------------
# load dotfiles environment paths
source "$(dirname "${BASH_SOURCE[0]}")/../../common/utils/env_paths.sh"
SDIR=$(sd)
# load package manager 
source "$SDIR/utils/pkg_bootstrap.sh"
source "$DOTFILES_COMMON_UTILS/pkg.sh"
# load package library

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Rust setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  # Dependencies
  pkg_install curl build-essential

  # -------------------------------------------------
  # Install rustup (if missing)
  # -------------------------------------------------
  if ! command -v rustup >/dev/null 2>&1; then
    echo "==> Installing rustup"

    curl https://sh.rustup.rs -sSf | sh -s -- -y

    # Load cargo env for current session
    if [[ -f "$HOME/.cargo/env" ]]; then
      # shellcheck source=/dev/null
      source "$HOME/.cargo/env"
    fi
  else
    echo "✔ rustup already installed"
  fi

  # -------------------------------------------------
  # Ensure stable toolchain
  # -------------------------------------------------
  if command -v rustup >/dev/null 2>&1; then
    rustup default stable
  else
    echo "⚠️ rustup not available, skipping toolchain setup"
  fi

  # -------------------------------------------------
  # Sanity checks (non-fatal)
  # -------------------------------------------------
  echo "==> Verifying installation..."

  if command -v rustc >/dev/null 2>&1; then
    echo "🦀 rustc: $(rustc --version)"
  else
    echo "⚠️ rustc not found"
  fi

  if command -v cargo >/dev/null 2>&1; then
    echo "📦 cargo: $(cargo --version)"
  else
    echo "⚠️ cargo not found"
  fi

  echo "✔ Rust setup complete"
}

# -------------------------------------------------
# Entrypoint (direct execution support)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
fi
