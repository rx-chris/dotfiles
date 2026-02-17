#!/bin/bash

# --- Configuration & Styles ---
DOTFILES="$HOME/dotfiles"
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Helper Functions ---

# Log a status message
log_info() {
    echo -e "${BLUE}🚀 $1${NC}"
}

# Log a success message
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Run a command silently, but show error if it fails
execute_quietly() {
    local task_name=$1
    shift # Remove the first argument, leaving the command
    
    echo -n "⏳ $task_name... "
    if "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}Done!${NC}"
    else
        echo -e "${RED}Failed!${NC}"
        return 1
    fi
}

# --- Main Script ---

log_info "Starting Ubuntu Dotfiles Setup"

# 1. Dependencies
execute_quietly "Installing dependencies" \
    sudo apt update && sudo apt install -y zsh git stow curl fontconfig

# 2. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    execute_quietly "Installing Oh My Zsh" \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Plugins
mkdir -p "$ZSH_PLUGINS_DIR"
[ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ] && \
    execute_quietly "Installing zsh-autosuggestions" \
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"

[ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ] && \
    execute_quietly "Installing zsh-syntax-highlighting" \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"

# 4. Fonts
execute_quietly "Downloading MesloLGS NF Regular" \
    curl -L https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/P10k/MesloLGS%20NF%20Regular.ttf -o ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf

execute_quietly "Refreshing font cache" fc-cache -fv

# 5. Stow (Keep this one slightly more visible as it's the core of the script)
log_info "Linking configurations with Stow"
cd "$DOTFILES" || exit
stow -v zsh

log_success "Setup complete! Please restart your terminal."
