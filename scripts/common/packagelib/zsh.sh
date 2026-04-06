install_zsh() {
  pkg_install zsh git curl
}

configure_zsh() {
  local zsh_path current_shell

  zsh_path="$(command -v zsh)"
  current_shell="$(getent passwd "$USER" | cut -d: -f7 || true)"

  if [[ "$current_shell" == "$zsh_path" ]]; then
    echo "✅ zsh is already your default shell"
    return 0
  fi

  if chsh -s "$zsh_path" 2>/dev/null; then
    echo "✅ Default shell changed to zsh via chsh"
    echo "🔄 Restart terminal to apply changes"
    return 0
  fi

  echo "⚠️ chsh failed, trying /etc/passwd..."

  if [[ ! -w /etc/passwd ]]; then
    echo "❌ No permission to edit /etc/passwd"
    return 1
  fi

  if sed -i "s|^\($USER:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\).*|\1$zsh_path|" /etc/passwd; then
    echo "✅ /etc/passwd updated successfully"
    echo "🔄 Restart terminal to apply changes"
    return 0
  fi

  echo "❌ Failed to update /etc/passwd"
  return 1
}
