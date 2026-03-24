run() {
  echo "==> zsh"

  # install shell
  if ! command -v zsh >/dev/null 2>&1; then
    sudo apt install -y zsh
  fi

  # apply config
  stow --restow zsh

  ZSH_PATH="$(which zsh)"

  # try to register shell (ignore failure)
  if [ -w /etc/shells ]; then
    grep -qx "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi

  # set default shell (safe check) 
  if [ "$SHELL" != "$(which zsh)" ]; then 
    chsh -s "$(which zsh)" 
  fi
  echo "zsh setup complete. restart your terminal."
}
