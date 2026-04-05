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
# Resolve CLI arguments (direct execution only)
# -------------------------------------------------
resolve_arguments() { :; }

# -------------------------------------------------
# Resolve bootstrapped environment variables 
# -------------------------------------------------
resolve_bootstrap_env() { :; }
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
# Configure phase
# -------------------------------------------------
configure() { :; }

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    resolve_arguments "$@"
    install
    configure
fi
