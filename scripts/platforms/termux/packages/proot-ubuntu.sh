#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/pkg_bootstrap.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../../../common/utils/pkg.sh"

# -------------------------------------------------
# Package header
# -------------------------------------------------
echo "==> Proot Ubuntu setup"

# -------------------------------------------------
# resolve credentials
# -------------------------------------------------
resolve_credentials() {

  local cli_user="${1:-}"
  local cli_pass="${2:-}"

  # -------------------------------------------------
  # Priority: CLI > ENV > GLOBAL DEFAULT
  # -------------------------------------------------
  UBUNTU_USERNAME="${cli_user:-${UBUNTU_USERNAME:-${USERNAME:-dev}}}"
  UBUNTU_PASSWORD="${cli_pass:-${UBUNTU_PASSWORD:-${PASSWORD:-dev}}}"

  echo "User: $UBUNTU_USERNAME"
}

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {

  pkg_install proot-distro

  # -------------------------------------------------
  # Termux-only guard
  # -------------------------------------------------
  [[ -d "$PREFIX" ]] || {
    echo "❌ This package is only for Termux"
    exit 1
  }

  local DISTRO="ubuntu"

  # -------------------------------------------------
  # Install Ubuntu if missing
  # -------------------------------------------------
  if proot-distro list | grep -q "$DISTRO"; then
    echo "✔ Ubuntu already installed"
  else
    echo "==> Installing Ubuntu"
    proot-distro install "$DISTRO"
  fi

  # -------------------------------------------------
  # Resolve credentials (CLI args passed here)
  # -------------------------------------------------
  resolve_credentials "$@"

  # -------------------------------------------------
  # Provision Ubuntu system
  # -------------------------------------------------
  proot-distro login "$DISTRO" -- bash -c "

    set -e

    apt update && apt upgrade -y
    apt install -y sudo

    # create user if not exists
    id -u $UBUNTU_USERNAME >/dev/null 2>&1 || \
      useradd -m -s /bin/bash $UBUNTU_USERNAME

    # set password
    echo '$UBUNTU_USERNAME:$UBUNTU_PASSWORD' | chpasswd

    # add sudo group
    usermod -aG sudo $UBUNTU_USERNAME

    # safe sudoers entry (no duplicates)
    if ! grep -q '$UBUNTU_USERNAME ALL=(ALL:ALL) ALL' /etc/sudoers; then
      echo '$UBUNTU_USERNAME ALL=(ALL:ALL) ALL' >> /etc/sudoers
    fi

    echo '✔ Ubuntu setup complete'
  "

  # -------------------------------------------------
  # Final output
  # -------------------------------------------------
  echo ""
  echo "✔ Proot Ubuntu ready"
  echo "Login:"
  echo "  proot-distro login ubuntu --user $UBUNTU_USERNAME"
}

# -------------------------------------------------
# Entrypoint (direct execution support)
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install "$@"
fi
