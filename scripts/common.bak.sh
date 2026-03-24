#!/usr/bin/env bash

# -----------------------------
# Common utilities for dotfiles
# -----------------------------

# ---- Strict mode (optional if sourced by strict script) ----
# set -euo pipefail

# ---- DOTFILES Root ----
DOTFILES="$HOME/dotfiles"

# ---- Colors ----
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# ---- Logging ----
log_info() {
    echo -e "${BLUE}🚀 $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warn() {
    echo -e "${RED}⚠️  $1${NC}"
}

# ---- Package Installer (Ubuntu) ----
install_package() {
    if [ "$#" -eq 0 ]; then
        log_error "install_package requires at least one package name"
        return 1
    fi

    local missing=()

    for pkg in "$@"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            missing+=("$pkg")
        else
            log_info "$pkg already installed"
        fi
    done

    if [ "${#missing[@]}" -gt 0 ]; then
        log_info "Installing: ${missing[*]}"
        sudo apt-get install -y "${missing[@]}"
        log_success "Installation complete"
    fi
}
