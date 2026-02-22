#!/bin/bash
set -euo pipefail

# Pro-level safety guard
: "${DOTFILES:?Run install.sh instead of this script directly}"

source "$DOTFILES/scripts/common.sh"

log_info "Setting up Zsh"

ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    execute_quietly "Installing Oh My Zsh" \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install plugins
mkdir -p "$ZSH_PLUGINS_DIR"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    execute_quietly "Installing zsh-autosuggestions" \
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    execute_quietly "Installing zsh-syntax-highlighting" \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Fonts (for Powerlevel10k / Nerd Font)
mkdir -p ~/.local/share/fonts

execute_quietly "Downloading MesloLGS NF Regular" \
    curl -L https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/P10k/MesloLGS%20NF%20Regular.ttf \
    -o ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf

execute_quietly "Refreshing font cache" fc-cache -fv

# Stow zsh config
log_info "Linking Zsh config with Stow"
cd "$DOTFILES"
stow -v zsh

# Set default shell to zsh (Ubuntu proot safe)
if [ "$SHELL" != "$(command -v zsh)" ]; then
    log_info "Changing default shell to zsh"
    chsh -s "$(command -v zsh)" || log_error "Could not change shell automatically"
fi

log_success "Zsh setup complete"
