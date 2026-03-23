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

  # attempt chsh, fallback if it fails
  if [ "$SHELL" != "$ZSH_PATH" ]; then
    if chsh -s "$ZSH_PATH" 2>/dev/null; then
      echo "Default shell changed via chsh"
    else
      echo "chsh failed, falling back to rc exec"
      grep -qx 'exec zsh' ~/.bashrc || echo 'exec zsh' >> ~/.bashrc
    fi
  fi

  echo "zsh setup complete. restart your terminal."
}
