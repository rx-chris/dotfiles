run() {
  echo "==> git"

  # ------------------------------------------------------------
  # Install dependencies (idempotent)
  # ------------------------------------------------------------
  install_if_missing git git
  install_if_missing ssh openssh-client

  # ------------------------------------------------------------
  # Validate required environment variables (.env)
  # ------------------------------------------------------------
  # These must be provided via bootstrap.sh:
  #   GIT_USERNAME
  #   GIT_EMAIL
  # ------------------------------------------------------------
  if [ -z "${GIT_USERNAME:-}" ] || [ -z "${GIT_EMAIL:-}" ]; then
    echo "ERROR: Missing GIT_USERNAME or GIT_EMAIL in .env"
    return 1
  fi

  # ------------------------------------------------------------
  # Configure global git identity (only if needed)
  # ------------------------------------------------------------
  CURRENT_NAME=$(git config --global user.name || true)
  CURRENT_EMAIL=$(git config --global user.email || true)

  if [ "$CURRENT_NAME" != "$GIT_USERNAME" ]; then
    git config --global user.name "$GIT_USERNAME"
    echo "set git user.name"
  else
    echo "git user.name already set"
  fi

  if [ "$CURRENT_EMAIL" != "$GIT_EMAIL" ]; then
    git config --global user.email "$GIT_EMAIL"
    echo "set git user.email"
  else
    echo "git user.email already set"
  fi

  git config --global core.autocrlf input
  git config --global pull.rebase false

  # ------------------------------------------------------------
  # SSH key setup (idempotent)
  # ------------------------------------------------------------
  SSH_DIR="$HOME/.ssh"
  KEY="$SSH_DIR/id_ed25519"

  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"

  if [ ! -f "$KEY" ]; then
    echo "generating SSH key..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$KEY" -N ""
  else
    echo "SSH key already exists"
  fi

  # ------------------------------------------------------------
  # ssh-agent (avoid duplicate startup)
  # ------------------------------------------------------------
  if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    echo "starting ssh-agent"
    eval "$(ssh-agent -s)" >/dev/null 2>&1
  else
    echo "ssh-agent already running"
  fi

  if ! ssh-add -l 2>/dev/null | grep -q "$KEY"; then
    ssh-add "$KEY"
    echo "added SSH key to agent"
  else
    echo "SSH key already added"
  fi

  # ------------------------------------------------------------
  # SSH config for GitHub (idempotent append)
  # ------------------------------------------------------------
  SSH_CONFIG="$SSH_DIR/config"

  if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
    cat >> "$SSH_CONFIG" <<EOF

Host github.com
  HostName github.com
  User git
  IdentityFile $KEY
  AddKeysToAgent yes
EOF
    chmod 600 "$SSH_CONFIG"
    echo "added github SSH config"
  else
    echo "github SSH config already exists"
  fi

  # ------------------------------------------------------------
  # Output SSH public key (no blocking prompts)
  # ------------------------------------------------------------
  echo ""
  echo "==> GitHub SSH key generated"
  echo ""
  echo "Add this key to GitHub:"
  echo "https://github.com/settings/keys"
  echo ""

  echo "----------------------------------------"
  cat "${KEY}.pub"
  echo "----------------------------------------"

  echo ""
  echo "To verify after adding the key:"
  echo "  ssh -T git@github.com"
}
