#!/bin/bash

# Define paths
DOTFILES="$HOME/dotfiles"

echo "🚀 Starting Robust Ubuntu Dotfiles Setup..."

# 1. Install System Dependencies (Added fontconfig for fonts)
sudo apt update && sudo apt install -y zsh git stow curl fontconfig

# 2. Install Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎁 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Install Powerlevel10k & Plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 4. Install MesloLGS NF Fonts (Required for P10k)
echo "📂 Installing Nerd Fonts..."
mkdir -p ~/.local/share/fonts
curl -L https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/P10k/MesloLGS%20NF%20Regular.ttf -o ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf
# (Repeat curl for Bold, Italic, Bold Italic if desired)
fc-cache -fv

# 5. Stow Configurations
echo "🔗 Linking dotfiles..."
cd "$DOTFILES"

# Safety check: Remove existing .zshrc if it's not a symlink
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"

stow zsh

# 6. Set Zsh as Default Shell (Using 'command -v' instead of 'which')
ZSH_PATH=$(command -v zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "🐚 Changing default shell to Zsh..."
    chsh -s "$ZSH_PATH"
fi

echo "✨ All done! IMPORTANT: Manually change your Terminal font to 'MesloLGS NF'."
