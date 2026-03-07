#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Zsh Setup Script (Ubuntu)
# -----------------------------

source "$HOME/dotfiles/scripts/common.sh"

log_info "Starting Zsh setup"

# ---- Install required packages ----
install_package zsh stow

# ---- Stow Zsh configuration ----
log_info "Stowing Zsh configuration"
cd "$DOTFILES"
stow -v zsh
log_success "Zsh dotfiles stowed"

# ---- Change default shell to Zsh ----
ZSH_PATH="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    log_info "Changing default shell to $ZSH_PATH"
    chsh -s "$ZSH_PATH"
    log_success "Default shell updated"
else
    log_info "Zsh already the default shell"
fi

log_success "Zsh setup complete. Restart your terminal."
