#!/bin/bash
# Auto-update/install latest Neovim if needed (WSL/proot friendly)

# Detect architecture
ARCH=$(dpkg --print-architecture)
echo "Detected architecture: $ARCH"

# Determine download URL and directory
if [ "$ARCH" = "amd64" ]; then
    NVIM_DIR="nvim-linux-x86_64"
elif [ "$ARCH" = "arm64" ]; then
    NVIM_DIR="nvim-linux-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Get latest release tag from GitHub
LATEST=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
echo "Latest Neovim version: $LATEST"

# Check installed version
if command -v nvim >/dev/null 2>&1; then
    INSTALLED=$(nvim --version | head -n1 | awk '{print $2}')
    echo "Installed Neovim version: $INSTALLED"
else
    INSTALLED="0"
    echo "Neovim not installed."
fi

# Compare versions (skip if already latest)
if [ "$INSTALLED" = "$LATEST" ]; then
    echo "Neovim is already up-to-date. Skipping installation."
    exit 0
fi

# Download latest Neovim
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/$NVIM_DIR.tar.gz"
echo "Downloading $NVIM_URL ..."
curl -LO $NVIM_URL

# Remove old installation
sudo rm -rf /opt/$NVIM_DIR

# Extract to /opt
sudo tar -C /opt -xzf $(basename $NVIM_URL)

# Remove the downloaded tar.gz file
rm -f $(basename $NVIM_URL)

# Add to Zsh PATH if not already present
ZSHRC="$HOME/.zshrc"
if ! grep -q "/opt/$NVIM_DIR/bin" "$ZSHRC"; then
    echo "export PATH=/opt/$NVIM_DIR/bin:\$PATH" >> "$ZSHRC"
    echo "Added Neovim to PATH in $ZSHRC"
fi

# Verify installation
echo "Neovim version installed:"
nvim --version | head -n1

echo "Reload your .zshrc file:"
echo "source ~/.zshrc"
