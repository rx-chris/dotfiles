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

# -------------------------------------------------
# Package header
# -------------------------------------------------
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
