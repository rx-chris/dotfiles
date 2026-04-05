#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Guard
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "❌ Do not source this script. Run it directly."
  return 1 2>/dev/null || exit 1
fi

# -------------------------------------------------
# Logging
# -------------------------------------------------
log() { echo "==> $*"; }
err() { echo "❌ $*" >&2; exit 1; }

# -------------------------------------------------
# Dry-run
# -------------------------------------------------
DRY_RUN=0
run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

# -------------------------------------------------
# Core
# -------------------------------------------------
load_core() {
  source "$(dirname "${BASH_SOURCE[0]}")/common/utils/env_paths.sh"

  source "$DOTFILES_COMMON_UTILS/config.sh"
  source "$DOTFILES_COMMON_UTILS/pkg.sh"
  source "$DOTFILES_COMMON_UTILS/env_detect/detect_platform.sh"
  source "$DOTFILES_COMMON_UTILS/env_detect/detect_runtime.sh"

  ENV_PLATFORM=$(detect_platform)
  ENV_RUNTIME=$(detect_runtime "$ENV_PLATFORM")

  source "$DOTFILES_PACKAGES/$ENV_PLATFORM/utils/pkg_bootstrap.sh"
}

# -------------------------------------------------
# Phases
# -------------------------------------------------
init() {
  PKG="${1:-}"
  [[ -n "$PKG" ]] || err "Usage: $0 <package> [--dry-run]"

  [[ "${2:-}" == "--dry-run" ]] && {
    DRY_RUN=1
    log "Dry-run mode enabled"
  }

  load_core

  if [[ -f "$DOTFILES_ROOT/.env" ]]; then
    log "Loading .env"
    set -a
    source "$DOTFILES_ROOT/.env"
    set +a
  fi
}

resolve() {
  PKG_SCRIPT="$DOTFILES_PACKAGES/$ENV_PLATFORM/$PKG.sh"
  PLATFORM_OVERLAY_DIR="$DOTFILES_CONFIG_OVERLAYS/$ENV_PLATFORM"
  RUNTIME_OVERLAY_DIR="$DOTFILES_CONFIG_OVERLAYS/$ENV_PLATFORM/$ENV_RUNTIME"

  log "Platform : $ENV_PLATFORM"
  log "Runtime  : $ENV_RUNTIME"
  log "Package  : $PKG"

  [[ -f "$PKG_SCRIPT" ]] || \
    err "Package not found for platform '$ENV_PLATFORM': $PKG"
}

load_package() {
  log "Loading package script"
  source "$PKG_SCRIPT" || err "Failed to load $PKG_SCRIPT"

  # Enforce strict contract
  for fn in resolve_bootstrap_env install configure; do
    declare -f "$fn" >/dev/null || \
      err "$fn() missing in $PKG_SCRIPT"
  done
}

install_phase() {
  log "Resolving package environment"
  resolve_bootstrap_env

  log "Running install()"
  run install
}

apply_layer() {
  local label="$1"
  local dir="$2"

  if [[ -d "$dir/$PKG" ]]; then
    log "Applying $label overlay"
    run reapply_config_overlay "$PKG" "$dir"
  else
    log "Skipping $label overlay"
  fi
}

configure_phase() {
  if [[ -d "$DOTFILES_BASE_CONFIGS/$PKG" ]]; then
    log "Applying base config"
    run reapply_base_config "$PKG" "$DOTFILES_BASE_CONFIGS"
  else
    log "No base config found"
  fi

  apply_layer "platform" "$PLATFORM_OVERLAY_DIR"
  apply_layer "runtime" "$RUNTIME_OVERLAY_DIR"

  log "Running configure()"
  run configure
}

# -------------------------------------------------
# Main
# -------------------------------------------------
main() {
  init "$@"
  resolve
  load_package
  install_phase
  configure_phase
  log "Done"
}

main "$@"
