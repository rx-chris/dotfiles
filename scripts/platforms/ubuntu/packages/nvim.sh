#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/install_if_missing.sh"

echo "==> Neovim setup"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {
  install_if_missing curl tar

  # -------------------------------------------------
  # Detect architecture
  # -------------------------------------------------
  local arch
  arch="$(dpkg --print-architecture)"

  echo "Detected architecture: $arch"

  local nvim_dir=""
  case "$arch" in
    amd64) nvim_dir="nvim-linux-x86_64" ;;
    arm64) nvim_dir="nvim-linux-arm64" ;;
    *)
      echo "❌ Unsupported architecture: $arch"
      return 1
      ;;
  esac

  # -------------------------------------------------
  # Get latest version
  # -------------------------------------------------
  local latest
  latest="$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')"

  echo "Latest Neovim version: $latest"

  # -------------------------------------------------
  # Check installed version
  # -------------------------------------------------
  local installed="0"

  if command -v nvim >/dev/null 2>&1; then
    installed="$(nvim --version | head -n1 | awk '{print $2}')"
    echo "Installed Neovim version: $installed"
  else
    echo "Neovim not installed"
  fi

  # -------------------------------------------------
  # Skip if up-to-date
  # -------------------------------------------------
  if [[ "$installed" == "$latest" ]]; then
    echo "✔ Neovim already up-to-date"
    return 0
  fi

  # -------------------------------------------------
  # Download + install
  # -------------------------------------------------
  local url="https://github.com/neovim/neovim/releases/latest/download/${nvim_dir}.tar.gz"
  local file="$(basename "$url")"

  echo "Downloading $url ..."
  curl -LO "$url"

  sudo rm -rf "/opt/$nvim_dir"
  sudo tar -C /opt -xzf "$file"
  rm -f "$file"

  echo "✔ Neovim installed to /opt/$nvim_dir"
}

# -------------------------------------------------
# configure phase (runs AFTER stow)
# -------------------------------------------------
configure() {
  local arch
  arch="$(dpkg --print-architecture)"

  local nvim_dir=""
  case "$arch" in
    amd64) nvim_dir="nvim-linux-x86_64" ;;
    arm64) nvim_dir="nvim-linux-arm64" ;;
    *) return 0 ;;
  esac

  local nvim_bin="/opt/$nvim_dir/bin"

  echo "==> Configuring Neovim"

  # -------------------------------------------------
  # Add to PATH (idempotent)
  # -------------------------------------------------
  local shell_rc="$HOME/.zshrc"

  if [[ -f "$shell_rc" ]]; then
    if ! grep -q "$nvim_bin" "$shell_rc"; then
      echo "export PATH=$nvim_bin:\$PATH" >> "$shell_rc"
      echo "✔ Added Neovim to PATH"
    else
      echo "✔ PATH already configured"
    fi
  fi

  # -------------------------------------------------
  # Sanity check
  # -------------------------------------------------
  if command -v nvim >/dev/null 2>&1; then
    echo "🧠 nvim: $(nvim --version | head -n1)"
  else
    echo "⚠️ nvim not found in PATH (reload shell required)"
  fi
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install
  configure
fi
