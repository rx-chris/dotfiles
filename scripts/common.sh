#!/usr/bin/env bash

# -------------------------------------------------
# Detect package manager
# -------------------------------------------------
detect_pkg_manager() {
  if [[ -n "${TERMUX_VERSION:-}" ]]; then
    echo "pkg"
  elif command -v apt >/dev/null 2>&1; then
    echo "apt"
  else
    echo "unknown"
  fi
}

PKG_MANAGER="$(detect_pkg_manager)"

# -------------------------------------------------
# Install if missing
# -------------------------------------------------
install_if_missing() {
  if [[ "$#" -eq 0 ]]; then
    echo "❌ No packages specified"
    return 1
  fi

  local pkg
  local missing=()

  # check each package
  for pkg in "$@"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done

  # nothing to install
  if [[ "${#missing[@]}" -eq 0 ]]; then
    echo "✔ already installed: $*"
    return 0
  fi

  # install missing
  case "$PKG_MANAGER" in
    apt)
      echo "==> sudo apt install: ${missing[*]}"
      sudo apt install -y "${missing[@]}"
      ;;
    pkg)
      echo "==> pkg install: ${missing[*]}"
      pkg install -y "${missing[@]}"
      ;;
    *)
      echo "❌ Unsupported package manager"
      return 1
      ;;
  esac
}
