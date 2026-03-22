run() {
  echo "==> nvm"

  NVM_VERSION="${NVM_VERSION:-v0.40.4}"
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

  # install if missing
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "Installing nvm..."
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
  fi

  # load into current shell
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  # install node if needed
  if ! command -v node >/dev/null 2>&1; then
    nvm install --lts
  fi

  nvm alias default 'lts/*' >/dev/null
  echo "✅ Node: $(node -v)"
}

