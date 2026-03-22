run() {
  echo "==> tmux"

  # install tmux
  if ! command -v tmux >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y tmux
  fi

  # stow config
  stow --restow tmux

  # install TPM (only once)
  TPM_DIR="$HOME/.tmux/plugins/tpm"

  if [ ! -d "$TPM_DIR" ]; then
    echo "installing TPM"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  fi

  echo "tmux ready"
  echo "run: Prefix + I inside tmux to install plugins"
}
