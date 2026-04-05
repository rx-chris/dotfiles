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

# Fail if any of the listed variables are unset or empty
validate_required() {
  for var in "$@"; do
    : "${!var:?Error: $var must be set}"
  done
}
# -------------------------------------------------
# Resolve CLI arguments (direct execution only)
# -------------------------------------------------
resolve_arguments() {
  if (( $# > 0 && $# != 4 )); then
    echo "Error: Expected 4 arguments: <GITHUB_EMAIL> <GITHUB_PAT> <GITHUB_SSH_KEY_NAME> <GITHUB_SSH_KEY_TITLE>"
    exit 1
  fi

  GITHUB_EMAIL="${1:-}"
  GITHUB_PAT="${2:-}"
  GITHUB_SSH_KEY_NAME="${3:-}"
  GITHUB_SSH_KEY_TITLE="${4:-}"

  validate_required GITHUB_EMAIL GITHUB_PAT GITHUB_SSH_KEY_NAME GITHUB_SSH_KEY_TITLE
}
# -------------------------------------------------
# Resolve bootstrapped environment variables 
# -------------------------------------------------
resolve_bootstrap_env() {
  GITHUB_EMAIL="${GITHUB_EMAIL:-${EMAIL:-}}"

  validate_required GITHUB_EMAIL GITHUB_PAT GITHUB_SSH_KEY_NAME GITHUB_SSH_KEY_TITLE
}
# -------------------------------------------------
# Install and configure
# -------------------------------------------------
install() {
  install_github_ssh
}

configure() {
  configure_github_ssh GITHUB_USERNAME GITHUB_EMAIL GITHUB_PAT GITHUB_SSH_KEY_NAME
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  resolve_arguments "$@"
  install
  configure
fi
