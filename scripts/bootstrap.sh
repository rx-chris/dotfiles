#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "==> Bootstrap start"

# load .env if it exists
if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

install_if_missing() {
  local cmd="$1"
  local pkg="${2:-$1}"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "installing $pkg..."
    sudo apt update
    sudo apt install -y "$pkg"
  else
    echo "$pkg already installed"
  fi
}

run_core() {
  source packages/core.sh
  run
}

run_pkg() {
  local pkg="$1"

  if [ ! -f "packages/$pkg.sh" ]; then
    echo "Unknown package: $pkg"
    exit 1
  fi

  source "packages/$pkg.sh"
  run
}

# ---- always run core once ----
run_core

# ---- require explicit packages ----
if [ $# -eq 0 ]; then
  echo "Usage: $0 <package> [package...]"
  exit 1
fi

for pkg in "$@"; do
  [ "$pkg" = "core" ] && continue
  run_pkg "$pkg"
done

echo "==> Done"
