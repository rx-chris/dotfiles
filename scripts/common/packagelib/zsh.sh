# -------------------------------------------------
# Load utilities & libraries
# -------------------------------------------------
# load dotfiles environment paths
source "$(dirname "${BASH_SOURCE[0]}")/../utils/env_paths.sh"
# load shell utilities
source "$DOTFILES_COMMON_UTILS/shell.sh"
# -----------------------------
# main install
# -----------------------------
install_zsh() {
  pkg_install zsh git curl
}

# -----------------------------
# main configure
# -----------------------------
configure_zsh() {
  local zsh_path
  zsh_path="$(command -v zsh)"

  if shell_is_default "$zsh_path"; then
    echo "✅ zsh already default"
    return 0
  fi

  # Ensure shell is registered in /etc/shells
  ensure_shell_registered "$zsh_path"

  set_default_shell "$zsh_path"
}
