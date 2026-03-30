#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load platform utilities
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/../utils/install_if_missing.sh"

echo "==> Nerd Fonts (Termux)"

# -------------------------------------------------
# install phase
# -------------------------------------------------
install() {

  install_if_missing curl unzip

  # Termux-only guard
  [[ -d "$PREFIX" ]] || {
    echo "❌ Termux only"
    exit 1
  }

  local DIR="$HOME/.termux"
  local URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
  local ZIP="$DIR/JetBrainsMono.zip"

  mkdir -p "$DIR"

  echo "==> Downloading"
  [[ -f "$ZIP" ]] || curl -L -o "$ZIP" "$URL"

  echo "==> Installing"
  unzip -o "$ZIP" -d "$DIR" >/dev/null

  cp -f "$DIR/JetBrainsMonoNerdFontMono-Regular.ttf" "$DIR/font.ttf"

  termux-reload-settings 2>/dev/null || true

  echo "✔ Nerd Font installed"
  echo "   "
}

# -------------------------------------------------
# Entrypoint
# -------------------------------------------------
[[ "${BASH_SOURCE[0]}" == "$0" ]] && install
