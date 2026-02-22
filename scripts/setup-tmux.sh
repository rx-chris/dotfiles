#!/bin/bash
set -euo pipefail

# Pro-level safety guard
: "${DOTFILES:?Run install.sh instead of this script directly}"

source "$DOTFILES/scripts/common.sh"

log_info "Setting up tmux"

# Stow tmux config
cd "$DOTFILES"
stow -v tmux

# Install TPM if missing
mkdir -p ~/.tmux/plugins

if [ ! -d ~/.tmux/plugins/tpm ]; then
    execute_quietly "Installing TPM" \
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Auto-install tmux plugins (no prefix+I needed)
if command -v tmux >/dev/null 2>&1; then
    tmux start-server
    tmux new-session -d -s __dotfiles_bootstrap "sleep 1"
    ~/.tmux/plugins/tpm/bin/install_plugins > /dev/null 2>&1
    tmux kill-session -t __dotfiles_bootstrap 2>/dev/null || true
fi

log_success "tmux setup complete"
