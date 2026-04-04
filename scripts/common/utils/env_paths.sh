#!/usr/bin/env bash
# -------------------------------------------------------------------
# Dotfiles environment paths
# Provides absolute paths to all main directories in the repo
# Source this in any script for easy access
# -------------------------------------------------------------------

# Prevent double sourcing
if [ -n "${DOTFILES_ENV_PATHS_LOADED:-}" ]; then
    return
fi
export DOTFILES_ENV_PATHS_LOADED=1

# -------------------------
# Root of the dotfiles repo
# -------------------------
if [ -z "${DOTFILES_ROOT:-}" ]; then
    DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
fi

# -------------------------
# Scripts directories
# -------------------------
DOTFILES_SCRIPTS="$DOTFILES_ROOT/scripts"
DOTFILES_COMMON="$DOTFILES_SCRIPTS/common"
DOTFILES_COMMON_UTILS="$DOTFILES_COMMON/utils"
DOTFILES_COMMON_PACKAGELIB="$DOTFILES_COMMON/packagelib"
DOTFILES_PACKAGES="$DOTFILES_SCRIPTS/packages"

# -------------------------
# Configuration directories (stowable)
# -------------------------
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_BASE_CONFIGS="$DOTFILES_CONFIG/base"
DOTFILES_CONFIG_OVERLAYS="$DOTFILES_CONFIG/overlays"   # environment-specific

# -------------------------
# Helper: get absolute directory of the current script
# Usage: SDIR=$(sd)
# -----------------------------------------------------------------
sd() { echo "$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd -P)"; }

# -------------------------
# Optional debug output
# -------------------------
# Uncomment to see resolved paths
# echo "DOTFILES_ROOT=$DOTFILES_ROOT"
# echo "DOTFILES_SCRIPTS=$DOTFILES_SCRIPTS"
# echo "DOTFILES_COMMON=$DOTFILES_COMMON"
# echo "DOTFILES_COMMON_UTILS=$DOTFILES_COMMON_UTILS"
# echo "DOTFILES_COMMON_PACKAGELIB=$DOTFILES_COMMON_PACKAGELIB"
# echo "DOTFILES_PACKAGES=$DOTFILES_PACKAGES"
# echo "DOTFILES_CONFIG=$DOTFILES_CONFIG"
# echo "DOTFILES_BASE_CONFIGS=$DOTFILES_BASE_CONFIGS"
# echo "DOTFILES_CONFIG_OVERLAYS=$DOTFILES_CONFIG_OVERLAYS"
