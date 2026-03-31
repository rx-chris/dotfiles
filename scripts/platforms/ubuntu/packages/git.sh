#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform installer
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/pkg_bootstrap.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../common/utils/pkg.sh"

# -------------------------------------------------
# Load shared git logic
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../../common/packages/git.sh"

echo "==> Git (Ubuntu)"

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
