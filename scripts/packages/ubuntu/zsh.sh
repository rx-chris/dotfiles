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
source "$DOTFILES_COMMON_PACKAGELIB/zsh.sh"
# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Zsh setup"
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
  install_zsh
}
# -------------------------------------------------
# configure phase (runs AFTER stow)
# -------------------------------------------------
configure() {
  configure_zsh
}

# -------------------------------------------------
# Entrypoint (only runs when executed directly)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    resolve_arguments "$@"
    install
    configure
fi
