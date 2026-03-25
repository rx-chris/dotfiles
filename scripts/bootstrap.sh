#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Prevent sourcing
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "❌ Do not source this script. Run it directly."
  return 1 2>/dev/null || exit 1
fi

# -------------------------------------------------
# Resolve paths
# -------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPTS_DIR="$DOTFILES/scripts"
STOW_ROOT="$DOTFILES/stow"

source "$(SCRIPT_DIR)/common/utils/detect_env.sh"

# -------------------------------------------------
# Load .env (global config)
# -------------------------------------------------
if [[ -f "$DOTFILES/.env" ]]; then
  echo "==> Loading .env"
  set -a
  source "$DOTFILES/.env"
  set +a
else
  echo "⚠️ .env file not found, continuing without it."
fi

# -------------------------------------------------
# Detect environment
# -------------------------------------------------
ENV="$(detect_env)"
if [[ -z "$ENV" ]]; then
  echo "❌ Could not detect environment. Exiting."
  exit 1
fi

# -------------------------------------------------
# Input validation
# -------------------------------------------------
PKG="${1:-}"
if [[ -z "$PKG" ]]; then
  echo "❌ No package name provided. Usage: $0 <package>"
  exit 1
fi

# -------------------------------------------------
# Resolve package paths (early!)
# -------------------------------------------------
STOW_PKG_DIR="$STOW_ROOT/$PKG"
if [[ ! -d "$STOW_PKG_DIR" ]]; then
  echo "⚠️ No stow package found for $PKG. Skipping stow step."
fi

# -------------------------------------------------
# Assign platform using the case statement
# -------------------------------------------------
case "$ENV" in
    termux)
        PLATFORM="termux"
        ;;
    proot-ubuntu|wsl-ubuntu|ubuntu)
        PLATFORM="ubuntu"
        ;;
    *)
        echo "❌ No installer defined for $ENV/$PKG"
        exit 1
        ;;
esac

# -------------------------------------------------
# Assign INSTALLER_SCRIPT and PKG_SCRIPT outside the case statement
# -------------------------------------------------
INSTALLER_SCRIPT="$DOTFILES/scripts/$PLATFORM/utils/install_if_missing.sh"
PKG_SCRIPT="$DOTFILES/scripts/$PLATFORM/$PKG.sh"

# -------------------------------------------------
# Ensure the installer script exists
# -------------------------------------------------
if [[ ! -f "$INSTALLER_SCRIPT" ]]; then
  echo "❌ Installer script not found for $PLATFORM. Exiting."
  exit 1
fi

# -------------------------------------------------
# Ensure the package script exists
# -------------------------------------------------
if [[ ! -f "$PKG_SCRIPT" ]]; then
  echo "❌ Package script not found: $PKG_SCRIPT. Exiting."
  exit 1
fi

# -------------------------------------------------
# Conditionally source the installer script
# -------------------------------------------------
echo "==> Detected $PLATFORM environment."
source "$INSTALLER_SCRIPT"

# -------------------------------------------------
# Debug info (optional but useful)
# -------------------------------------------------
echo "==> Base: $DOTFILES"
echo "==> Env:  $ENV"
echo "==> Pkg:  $PKG"

# -------------------------------------------------
# Install
# -------------------------------------------------
echo "==> Installing..."
bash "$PKG_SCRIPT"

# -------------------------------------------------
# Stow the package (if applicable)
# -------------------------------------------------
if [[ -d "$STOW_PKG_DIR" ]]; then
  echo "==> Stowing $PKG"
  cd "$STOW_ROOT"
  stow -v -t "$HOME" "$PKG"
else
  echo "⚠️ No stow package for $PKG (skipped)"
fi

# -------------------------------------------------
# Apply environment overlay if present
# -------------------------------------------------
#OVERLAY_DIR="$DOTFILES/overlays/$ENV/$PKG"
#if [[ -d "$OVERLAY_DIR" ]]; then
#    echo "==> Applying overlay for $ENV/$PKG"
#    cd "$OVERLAY_DIR"
#    stow -v -t ~ .
#fi

echo "==> Done"
