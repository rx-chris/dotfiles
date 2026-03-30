#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/install_if_missing.sh"

# -------------------------------------------------
# Load GitHub SSH module
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../../common/packagelib/github/ssh.sh"

echo "==> GitHub SSH (Termux)"

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
