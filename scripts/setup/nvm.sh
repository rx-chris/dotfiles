#!/bin/zsh

# 1. Config
NVM_VERSION="v0.40.1" # v0.40.4 isn't out yet, v0.40.1 is current!
export NVM_DIR="$HOME/.nvm"

# 2. Install NVM
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash

# 3. Load NVM into this session
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 4. Install Node & set default
nvm install --lts
nvm alias default 'lts/*'

# 5. Output result
echo "✅ Installed Node $(node -v)"
echo "🚀 Open a new terminal or run: source ~/.zshrc"
