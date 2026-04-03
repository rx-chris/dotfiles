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
# load package libraries
source "$DOTFILES_COMMON_PACKAGELIB/git.sh"

# -------------------------------------------------
# Package Header
# -------------------------------------------------
echo "==> Git (Termux)"

# -------------------------------------------------
# Install and configure
# -------------------------------------------------
install() {
  install_git
}

configure() {
  configure_git "$@"
}

# -------------------------------------------------
# direct execution entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install "$@"
  configure "$@"
fi
