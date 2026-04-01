#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load utilities & libraries
# -------------------------------------------------
# load dotfiles environment paths
source "$(dirname "${BASH_SOURCE[0]}")/../../../common/utils/env_paths.sh"
SDIR=$(sd)
# load package manager 
source "$SDIR/../utils/pkg_bootstrap.sh"
source "$DOTFILES_COMMON_UTILS/pkg.sh"
# load package library
source "$DOTFILES_COMMON_PACKAGELIB/proot/proot_distro.sh"
source "$DOTFILES_COMMON_PACKAGELIB/proot/setup_ubuntu.sh"

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Proot Ubuntu setup"

# -------------------------------------------------
# Resolve CLI arguments & environment variables
# -------------------------------------------------
resolve_arguments() {
    local cli_user="${1:-}"
    local cli_pass="${2:-}"
    local cli_distro="${3:-}"
    local cli_alias="${4:-}"

    DISTRO="${cli_distro:-${PROOT_DISTRO:-ubuntu}}"
    DISTRO_ALIAS="${cli_alias:-${PROOT_DISRO_ALIAS:-$DISTRO}}"
    DISTRO_USER="${cli_user:-${UBUNTU_USERNAME:-${USERNAME:-dev}}}"
    DISTRO_PASS="${cli_pass:-${UBUNTU_PASSWORD:-${PASSWORD:-dev}}}"

    echo "Using distro: $DISTRO (alias: $DISTRO_ALIAS)"
    echo "Using user: $DISTRO_USER"
}

# -------------------------------------------------
# Install phase (wrapper)
# -------------------------------------------------
install() {
    install_proot_distro "$DISTRO" "$DISTRO_ALIAS"
}

# -------------------------------------------------
# Configure phase (wrapper)
# -------------------------------------------------
configure() {
    local setup_script="$DOTFILES_COMMON_PACKAGELIB/proot/setup_$DISTRO.sh"
    configure_proot_distro "$DISTRO_ALIAS" "$DISTRO_USER" "$DISTRO_PASS" "$setup_script"
}


# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    resolve_arguments "$@"
    install
    configure
fi
