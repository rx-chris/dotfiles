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
# Paths
# -------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)"

SCRIPTS_DIR="$DOTFILES/scripts"
PLATFORMS_DIR="$SCRIPTS_DIR/platforms"
STOW_ROOT="$DOTFILES/stow"
OVERLAYS_DIR="$DOTFILES/overlays"

# -------------------------------------------------
# Load environment detection
# -------------------------------------------------
source "$SCRIPTS_DIR/common/utils/detect_env.sh"
detect_env

# -------------------------------------------------
# Helpers
# -------------------------------------------------
require_file() {
  local file="$1"
  local msg="${2:-Missing file: $file}"

  [[ -f "$file" ]] || {
    echo "❌ $msg"
    exit 1
  }
}

stow_if_exists() {
  local dir="$1"
  local label="${2:-overlay}"

  if [[ -d "$dir" ]]; then
    echo "==> Applying $label"
    stow -d "$dir" -t "$HOME" .
  fi
}

load_env() {
  if [[ -f "$DOTFILES/.env" ]]; then
    echo "==> Loading .env"
    set -a
    source "$DOTFILES/.env"
    set +a
  fi
}

# -------------------------------------------------
# Input
# -------------------------------------------------
PKG="${1:-}"
[[ -n "$PKG" ]] || {
  echo "❌ Usage: $0 <package>"
  exit 1
}

# -------------------------------------------------
# Resolve package
# -------------------------------------------------
resolve_pkg_script() {
  local platform_pkg="$PLATFORMS_DIR/$ENV_PLATFORM/packages/$PKG.sh"

  [[ -f "$platform_pkg" ]] || {
    echo "❌ Package not found for platform '$ENV_PLATFORM': $PKG"
    exit 1
  }

  PKG_SCRIPT="$platform_pkg"
  echo "==> Using package: $PKG"
}

# -------------------------------------------------
# Paths setup
# -------------------------------------------------
resolve_paths() {
  STOW_PKG_DIR="$STOW_ROOT/$PKG"

  PLATFORM_OVERLAY="$OVERLAYS_DIR/$ENV_PLATFORM/$PKG"
  RUNTIME_OVERLAY="$OVERLAYS_DIR/$ENV_PLATFORM/$ENV_RUNTIME/$PKG"

  resolve_pkg_script
}

# -------------------------------------------------
# Validation
# -------------------------------------------------
validate_files() {
  require_file "$PKG_SCRIPT"
}

# -------------------------------------------------
# Install phase
# -------------------------------------------------
install_pkg() {
  echo "================================================="
  echo "Platform : $ENV_PLATFORM"
  echo "Runtime  : $ENV_RUNTIME"
  echo "Package  : $PKG"
  echo "================================================="

  echo "==> Loading package"
  source "$PKG_SCRIPT"

  declare -f install >/dev/null || {
    echo "❌ install() not found in $PKG_SCRIPT"
    exit 1
  }

  echo "==> Running install()"
  install
}

# -------------------------------------------------
# Stow base config
# -------------------------------------------------
stow_pkg() {
  stow_if_exists "$STOW_ROOT/$PKG" "base config: $PKG"
}

# -------------------------------------------------
# Overlays (platform → runtime)
# -------------------------------------------------
apply_overlays() {

  # Platform overlay
  if [[ -d "$PLATFORM_OVERLAY" ]]; then
    stow_if_exists "$PLATFORM_OVERLAY" "platform ($ENV_PLATFORM)"
  fi

  # Runtime overlay (more specific, overrides platform)
  if [[ -d "$RUNTIME_OVERLAY" ]]; then
    stow_if_exists "$RUNTIME_OVERLAY" "runtime ($ENV_PLATFORM/$ENV_RUNTIME)"
  fi
}

# -------------------------------------------------
# Configure phase (after stow + overlays)
# -------------------------------------------------
configure_pkg() {
  if declare -f configure >/dev/null; then
    echo "==> Running configure()"
    configure
  fi
}

# -------------------------------------------------
# Main
# -------------------------------------------------
main() {
  load_env
  resolve_paths
  validate_files

  install_pkg
  stow_pkg
  apply_overlays
  configure_pkg

  echo "==> Done"
}

main "$@"
