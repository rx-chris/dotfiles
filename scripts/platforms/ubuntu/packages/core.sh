#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/pkg_bootstrap.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../common/utils/pkg.sh"

echo "==> Core packages setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  pkg_install \
    git \
    curl \
    stow \
    xclip \
    eza \
    build-essential \
    fontconfig \
    tmux \
    fzf \
    bat \
    zoxide \
    lazygit

  echo "✔ Core packages setup complete"
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
fi
