run() {
  echo "==> zsh"

  # install shell
  if ! command -v zsh >/dev/null 2>&1; then
    sudo apt install -y zsh
  fi

  # apply config
  stow --restow zsh

  # set default shell (safe check)
  if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
  fi

  echo "zsh setup complete. restart your terminal."
}
