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
source "$DOTFILES_COMMON_PACKAGELIB/python.sh"

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Python setup"
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
  install_python
}
# -------------------------------------------------
# configure phase (runs AFTER stow)
# -------------------------------------------------
configure() {
  configure_python
}
# -------------------------------------------------
# Entrypoint (direct execution support)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    resolve_arguments "$@"
    install
    configure
fi
