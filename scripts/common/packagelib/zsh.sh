install_zsh() {
  pkg_install zsh git curl
}

# -----------------------------
# helpers
# -----------------------------

get_login_shell() {
  case "$(uname)" in
    Darwin)
      dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}'
      ;;
    *)
      getent passwd "$USER" | cut -d: -f7
      ;;
  esac
}

shell_is_default() {
  local target="$1"
  [[ "$(get_login_shell)" == "$target" ]]
}

ensure_shell_registered() {
  local shell_path="$1"

  [[ -f /etc/shells ]] || return 0
  grep -qx "$shell_path" /etc/shells && return 0

  echo "⚠️ $shell_path not in /etc/shells"

  if command -v sudo >/dev/null; then
    echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
    echo "✅ Added to /etc/shells"
  else
    echo "❌ Cannot update /etc/shells (no sudo)"
    return 1
  fi
}

set_default_shell() {
  local shell_path="$1"

  echo "👉 Changing shell to $shell_path"
  if chsh -s "$shell_path"; then
    echo "✅ Default shell updated"
    echo "🔄 Restart terminal to apply"
    return 0
  fi

  echo "❌ chsh failed"
  echo "👉 Try manually: chsh -s $shell_path"
  return 1
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

  ensure_shell_registered "$zsh_path"
  set_default_shell "$zsh_path"
}
