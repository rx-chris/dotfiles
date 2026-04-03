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
source "$DOTFILES_COMMON_PACKAGELIB/proot/proot_distro.sh"
source "$DOTFILES_COMMON_PACKAGELIB/proot/setup_ubuntu.sh"

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Proot Ubuntu setup"

# -------------------------------------------------
# Resolve CLI arguments (direct execution only)
# -------------------------------------------------
resolve_arguments() {
    DISTRO="${1:-ubuntu}"
    DISTRO_ALIAS="${2:-$DISTRO}"
    DISTRO_USER="${3:-dev}"
    DISTRO_PASS="${4:-dev}"

    echo "Using distro: $DISTRO (alias: $DISTRO_ALIAS)"
    echo "Using user: $DISTRO_USER"
}

# -------------------------------------------------
# Resolve bootstrapped environment variables 
# -------------------------------------------------
resolve_bootstrap_env() {
    # Ensure PROOT_DISTRO is set
    : "${PROOT_DISTRO?Error: PROOT_DISTRO is not set.}"

    # Ensure either UBUNTU_USERNAME or USERNAME, and UBUNTU_PASSWORD or PASSWORD are set
    : "${UBUNTU_USERNAME:-$USERNAME?Error: Either UBUNTU_USERNAME or USERNAME must be set.}"
    : "${UBUNTU_PASSWORD:-$PASSWORD?Error: Either UBUNTU_PASSWORD or PASSWORD must be set.}"

    # Assign values
    DISTRO="${PROOT_DISTRO}"
    DISTRO_ALIAS="${PROOT_DISTRO_ALIAS:-$DISTRO}"
    DISTRO_USER="${UBUNTU_USERNAME:-$USERNAME}"
    DISTRO_PASS="${UBUNTU_PASSWORD:-$PASSWORD}"
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
