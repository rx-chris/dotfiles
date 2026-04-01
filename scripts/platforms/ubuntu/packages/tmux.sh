#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/pkg_bootstrap.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../../common/utils/pkg.sh"

echo "==> tmux setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  pkg_install tmux
}

# -------------------------------------------------
# configure phase (runs AFTER stow)
# -------------------------------------------------
configure() {
  echo "==> Configuring tmux"

  TPM_DIR="$HOME/.tmux/plugins/tpm"

  if [[ ! -d "$TPM_DIR" ]]; then
    echo "==> Installing TPM"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  else
    echo "✔ TPM already installed"
  fi

  if command -v tmux >/dev/null 2>&1; then
    echo "🧩 tmux: $(tmux -V)"
  else
    echo "⚠️ tmux not found"
  fi

  echo "✔ tmux ready"
  echo "👉 Run: Prefix + I inside tmux to install plugins"
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
  configure
fi
