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
BASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPTS_DIR="$BASE_DIR/scripts"
STOW_ROOT="$BASE_DIR/stow"

# -------------------------------------------------
# Load .env (global config)
# -------------------------------------------------
if [[ -f "$BASE_DIR/.env" ]]; then
  echo "==> Loading .env"
  set -a
  source "$BASE_DIR/.env"
  set +a
fi

# -------------------------------------------------
# Detect environment
# -------------------------------------------------
detect_env() {
  if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "wsl"
  elif [[ -n "${TERMUX_VERSION:-}" ]]; then
    echo "termux"
  else
    echo "ubuntu"
  fi
}

ENV="$(detect_env)"

# -------------------------------------------------
# Input
# -------------------------------------------------
PKG="${1:-}"

if [[ -z "$PKG" ]]; then
  echo "Usage: $0 <package>"
  exit 1
fi

# -------------------------------------------------
# Resolve package paths (early!)
# -------------------------------------------------
PKG_SCRIPT="$SCRIPTS_DIR/$ENV/$PKG.sh"
STOW_PKG_DIR="$STOW_ROOT/$PKG"

# -------------------------------------------------
# Debug info (optional but useful)
# -------------------------------------------------
echo "==> Base: $BASE_DIR"
echo "==> Env:  $ENV"
echo "==> Pkg:  $PKG"

# -------------------------------------------------
# Install
# -------------------------------------------------
if [[ ! -f "$PKG_SCRIPT" ]]; then
  echo "❌ Missing script: $PKG_SCRIPT"
  exit 1
fi

echo "==> Installing..."
bash "$PKG_SCRIPT"

# -------------------------------------------------
# Stow
# -------------------------------------------------
if [[ -d "$STOW_PKG_DIR" ]]; then
  echo "==> Stowing $PKG"
  cd "$STOW_ROOT"
  stow -v -t ~ "$PKG"
else
  echo "⚠️ No stow package for  $PKG (skipped)"
fi

echo "==> Done"
