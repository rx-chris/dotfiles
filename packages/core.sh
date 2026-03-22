run() {
  echo "==> core"

  CORE_PKGS=(
    git
    curl
    stow
    xclip
    eza
    build-essential
    fontconfig
    tmux
    fzf
    bat
    zoxide
  )

  TO_INSTALL=()
  ALREADY_OK=()

  for pkg in "${CORE_PKGS[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      ALREADY_OK+=("$pkg")
    else
      TO_INSTALL+=("$pkg")
    fi
  done

  if [ "${#TO_INSTALL[@]}" -gt 0 ]; then
    echo "Installing: ${TO_INSTALL[*]}"
    sudo apt update
    sudo apt install -y "${TO_INSTALL[@]}"
  fi

  if [ "${#ALREADY_OK[@]}" -gt 0 ]; then
    echo "Already installed: ${ALREADY_OK[*]}"
  else
    echo "All core packages already installed"
  fi
}
