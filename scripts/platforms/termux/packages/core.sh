#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/pkg_bootstrap.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../../common/utils/pkg.sh"

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Core Termux setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {

  # -------------------------------------------------
  # Core CLI utilities
  # -------------------------------------------------
  pkg_install git curl wget unzip tar

  # -------------------------------------------------
  # Termux storage setup
  # -------------------------------------------------
  if command -v termux-setup-storage >/dev/null 2>&1; then
    if [[ ! -d "$HOME/storage" ]]; then
      echo "==> Setting up Termux storage"
      termux-setup-storage
    else
      echo "✔ Termux storage already configured"
    fi
  else
    echo "⚠️ termux-setup-storage not available"
  fi

  # -------------------------------------------------
  # Termux API support (optional but useful)
  # -------------------------------------------------
  if command -v pkg >/dev/null 2>&1; then
    if ! dpkg -s termux-api >/dev/null 2>&1; then
      echo "==> Installing Termux API"
      pkg install -y termux-api
    else
      echo "✔ Termux API already installed"
    fi
  else
    echo "⚠️ pkg not available (not in Termux?)"
  fi

  # -------------------------------------------------
  # Verification
  # -------------------------------------------------
  echo "-----------------------------"
  echo "git  : $(git --version 2>/dev/null || echo 'missing')"
  echo "curl : $(curl --version 2>/dev/null | head -n1 || echo 'missing')"
  echo "wget : $(wget --version 2>/dev/null | head -n1 || echo 'missing')"
  echo "-----------------------------"

  echo "✔ Core Termux environment ready"
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
[[ "${BASH_SOURCE[0]}" == "$0" ]] && install
