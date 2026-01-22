#!/bin/bash

# --- Environment Detection Functions ---
pkg_update() {
    if [ -n "$TERMUX_VERSION" ]; then
        pkg update -y
    else
        sudo apt update
    fi
}

pkg_install() {
    if [ -n "$TERMUX_VERSION" ]; then
        pkg install -y "$@"
    else
        sudo apt install -y "$@"
    fi
}

# --- Main Setup Logic ---

# 1. Update and Install Core Tools
pkg_update
pkg_install zsh git curl

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Setup Theme and Plugins
Z_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "Cloning Powerlevel10k and Plugins..."
[ ! -d "$Z_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$Z_CUSTOM/themes/powerlevel10k"
[ ! -d "$Z_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$Z_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$Z_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$Z_CUSTOM/plugins/zsh-syntax-highlighting"

# 4. Configure .zshrc
echo "Applying configurations..."
# Create .zshrc if it doesn't exist
touch ~/.zshrc

# Backup
cp ~/.zshrc ~/.zshrc.bak

# Delete existing definitions to keep it clean
sed -i '/^ZSH_THEME=/d' ~/.zshrc
sed -i '/^plugins=(/d' ~/.zshrc

# Append new settings
{
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"'
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)'
} >> ~/.zshrc

echo "------------------------------------------------"
echo "Setup complete! Please RESTART your terminal."
echo "------------------------------------------------"