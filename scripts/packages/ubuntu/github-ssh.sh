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
source "$DOTFILES_COMMON_PACKAGELIB/github/ssh.sh"

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> GitHub SSH (Ubuntu)"

# -------------------------------------------------
# Install and configure
# -------------------------------------------------
install() {
  install_github_ssh
}

configure() {
  configure_github_ssh "$@"
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install "$@"
  configure "$@"
fi
