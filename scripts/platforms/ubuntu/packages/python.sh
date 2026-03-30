#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/install_if_missing.sh"

echo "==> Python setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  # Core Python
  install_if_missing python3 python3-pip python3-venv

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
