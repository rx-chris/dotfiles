run() {
  echo "==> nvim"

  # install neovim
  if ! command -v nvim >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y neovim
  else
    echo "nvim already installed"
  fi

  # stow config
  stow --restow nvim

  # sanity check config location
  if [ ! -d "$HOME/.config/nvim" ]; then
    echo "warning: no nvim config found in ~/.config/nvim"
  fi

  echo "nvim ready"
  echo "plugin manager handles installs on first launch"
}
