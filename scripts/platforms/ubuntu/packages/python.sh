#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load utilities & libraries
# -------------------------------------------------
# load dotfiles environment paths
source "$(dirname "${BASH_SOURCE[0]}")/../../../common/utils/env_paths.sh"
SDIR=$(sd)
# load package manager 
source "$SDIR/../utils/pkg_bootstrap.sh"
source "$DOTFILES_COMMON_UTILS/pkg.sh"
# load package library

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Python setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  # Core Python
  pkg_install python3 python3-pip python3-venv

  echo "==> Verifying installation..."

  # -------------------------------------------------
  # Sanity checks (non-fatal)
  # -------------------------------------------------
  if command -v python3 >/dev/null 2>&1; then
    echo "🐍 Python: $(python3 --version)"
  else
    echo "⚠️ python3 not found after installation"
  fi

  if command -v pip3 >/dev/null 2>&1; then
    echo "📦 pip: $(pip3 --version | cut -d' ' -f1-2)"
  else
    echo "⚠️ pip3 not found after installation"
  fi

  echo "✔ Python setup complete"
}

# -------------------------------------------------
# Entrypoint (direct execution support)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
fi
