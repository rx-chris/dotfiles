#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/install_if_missing.sh"

echo "==> Node (NVM + Node.js) setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  install_if_missing curl git

  local NVM_VERSION="${NVM_VERSION:-v0.40.4}"
  local NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

  echo "NVM_DIR    : $NVM_DIR"
  echo "NVM_VERSION: $NVM_VERSION"

  # -------------------------------------------------
  # Install nvm (safe, no shell rc modification)
  # -------------------------------------------------
  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    echo "==> Installing nvm"

    PROFILE=/dev/null bash -c \
      "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash"

    echo "✔ nvm installed"
  else
    echo "✔ nvm already installed"
  fi

  # -------------------------------------------------
  # Load nvm into current shell (for install only)
  # -------------------------------------------------
  # shellcheck disable=SC1090
  source "$NVM_DIR/nvm.sh"

  # -------------------------------------------------
  # Install Node (LTS via nvm)
  # -------------------------------------------------
  if command -v node >/dev/null 2>&1; then
    echo "✔ node already installed: $(node -v)"
  else
    echo "==> Installing Node LTS"
    nvm install --lts
  fi

  # -------------------------------------------------
  # Set default Node version
  # -------------------------------------------------
  nvm alias default "lts/*" >/dev/null

  # -------------------------------------------------
  # Verification
  # -------------------------------------------------
  echo "-----------------------------"
  echo "Node: $(node -v)"
  echo "npm : $(npm -v)"
  echo "npx : $(npx -v)"
  echo "-----------------------------"

  # -------------------------------------------------
  # Important note for user shell behavior
  # -------------------------------------------------
  echo ""
  echo "ℹ️  Note:"
  echo "   NVM is NOT auto-loaded on shell startup."
  echo "   It is lazy-loaded via your ~/.zshrc.d system"
  echo "   (node/npm/nvm are initialized only when first used)"
  echo ""

  echo "✔ Node environment ready"
}

# -------------------------------------------------
# Entrypoint (direct execution support)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
fi
