#!/bin/bash
set -euo pipefail

# Detect repo root dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES="$SCRIPT_DIR"

source "$DOTFILES/scripts/common.sh"

log_info "Starting Ubuntu Dotfiles Setup"

execute_quietly "Installing dependencies" \
    sudo apt update && sudo apt install -y zsh git stow curl fontconfig tmux

bash "$DOTFILES/scripts/setup-zsh.sh"
bash "$DOTFILES/scripts/setup-tmux.sh"

log_success "Setup complete! Please restart your terminal."
