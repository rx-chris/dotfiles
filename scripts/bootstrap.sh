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
# load dotfiles environment paths
source "$(dirname "${BASH_SOURCE[0]}")/common/utils/env_paths.sh"

# -------------------------------------------------
# Load environment detection
# -------------------------------------------------
source "$DOTFILES_COMMON_UTILS/env_detect/detect_platform.sh"
source "$DOTFILES_COMMON_UTILS/env_detect/detect_runtime.sh"

ENV_PLATFORM=$(detect_platform)
ENV_RUNTIME=$(detect_runtime "$ENV_PLATFORM")

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
  if [[ -f "$DOTFILES_ROOT/.env" ]]; then
    echo "==> Loading .env"
    set -a
    source "$DOTFILES_ROOT/.env"
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
  local platform_pkg="$DOTFILES_PLATFORMS/$ENV_PLATFORM/packages/$PKG.sh"

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
  BASE_CONFIG="$DOTFILES_BASE_CONFIG/$PKG"

  PLATFORM_OVERLAY="$DOTFILES_CONFIG_OVERLAYS/$ENV_PLATFORM/$PKG"
  RUNTIME_OVERLAY="$DOTFILES_CONFIG_OVERLAYS/$ENV_PLATFORM/$ENV_RUNTIME/$PKG"

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
  stow_if_exists "$DOTFILES_BASE_CONFIG/$PKG" "base config: $PKG"
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
