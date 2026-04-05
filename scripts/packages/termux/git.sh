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
# Resolve CLI arguments (direct execution only)
# -------------------------------------------------
resolve_arguments() {
  GIT_USERNAME="${1:-dev}"
  GIT_EMAIL="${2:-dev@example.com}"
}
# -------------------------------------------------
# Resolve bootstrapped environment variables 
# -------------------------------------------------
resolve_bootstrap_env() {
  # Ensure either GIT_USERNAME or USERNAME, and GIT_EMAIL or EMAIL are set
  : "${GIT_USERNAME:-$USERNAME?Error: Either GIT_USERNAME or USERNAME must be set.}"
  : "${GIT_EMAIL:-$EMAIL?Error: Either GIT_EMAIL or EMAIL must be set.}"

  # Assign values
  GIT_USERNAME="${GIT_USERNAME:-$USERNAME}"
  GIT_EMAIL="${GIT_EMAIL:-$EMAIL}"
}
# -------------------------------------------------
# Install and configure
# -------------------------------------------------
install() {
  install_git
}

configure() {
  configure_git $GIT_USERNAME $GIT_EMAIL
}

# -------------------------------------------------
# direct execution entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    resolve_arguments "$@"
    install
    configure
fi
