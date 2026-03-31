#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load environment detection
# -------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common/utils/detect_env.sh"
detect_env

# -------------------------------------------------
# Package lists
# -------------------------------------------------
TERMUX_PACKAGES=(
  core
  nerd-fonts
  git
  github-ssh
  proot-ubuntu
)

UBUNTU_PACKAGES=(
  core
  git
  github-ssh
  tmux
  nvim
  zsh
  python
  rust
  nvm
)

# -------------------------------------------------
# Select package list
# -------------------------------------------------
case "$ENV_PLATFORM" in
  termux)
    PACKAGES=("${TERMUX_PACKAGES[@]}")
    ;;
  ubuntu)
    PACKAGES=("${UBUNTU_PACKAGES[@]}")
    ;;
  *)
    echo "❌ Unsupported platform: $ENV_PLATFORM"
    exit 1
    ;;
esac

# -------------------------------------------------
# Optional override via CLI
# -------------------------------------------------
if [[ "$#" -gt 0 ]]; then
  PACKAGES=("$@")
fi

# -------------------------------------------------
# Pause helper
# -------------------------------------------------
pause() {
  read -n 1 -s -r -p "Press any key to continue (Ctrl+C to exit)..."
  echo
}

# -------------------------------------------------
# Main loop
# -------------------------------------------------
for pkg in "${PACKAGES[@]}"; do
  echo
  echo "========================================"
  echo "Platform : $ENV_PLATFORM"
  echo "Installing: $pkg"
  echo "========================================"

  if "$SCRIPT_DIR/bootstrap.sh" "$pkg"; then
    echo "✔ $pkg completed"
  else
    echo "❌ $pkg failed"
    exit 1
  fi

  pause
done

echo "🎉 All packages installed"
