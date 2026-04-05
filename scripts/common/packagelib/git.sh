install_git() {
  pkg_install git
  echo "✔ git installed"
}

configure_git() {

  local name="${1:-}"
  local email="${2:-}"

  echo "Git user:  $name"
  echo "Git email: $email"

  local GITCONFIG="$HOME/.gitconfig"
  local LOCAL="$HOME/.gitconfig.local"

  cat > "$LOCAL" <<EOF
[user]
    name = $name
    email = $email
EOF

  if ! grep -q ".gitconfig.local" "$GITCONFIG" 2>/dev/null; then
    cat >> "$GITCONFIG" <<'EOF'

# -------------------------------------------------
# local git config
# -------------------------------------------------
[include]
    path = ~/.gitconfig.local
EOF
  fi

  echo "✔ git configured"
}
