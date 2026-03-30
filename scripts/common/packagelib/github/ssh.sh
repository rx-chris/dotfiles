#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load shared core
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/core.sh"

echo "==> GitHub SSH (common logic)"

# -------------------------------------------------
# install
# -------------------------------------------------
install_github_ssh() {
  install_if_missing openssh gh curl
}

# -------------------------------------------------
# generate ssh key
# -------------------------------------------------
generate_ssh_key() {

  local key_name="${GITHUB_SSH_KEY_NAME:-github}"
  local key_path="$HOME/.ssh/$key_name"

  mkdir -p "$HOME/.ssh"

  if [[ -f "$key_path" ]]; then
    echo "✔ SSH key exists: $key_path"
  else
    echo "==> Generating SSH key..."
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$key_path" -N ""
  fi

  eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
  ssh-add "$key_path" >/dev/null 2>&1 || true

  PUBLIC_KEY="$(cat "$key_path.pub")"
}

# -------------------------------------------------
# upload ssh key
# -------------------------------------------------
upload_ssh_key() {

  require_github_pat

  echo "==> Uploading SSH key to GitHub..."

  github_api -X POST "https://api.github.com/user/keys" \
    -d "$(cat <<EOF
{
  "title": "$(hostname)-$(date +%s)",
  "key": "$PUBLIC_KEY"
}
EOF
)" >/dev/null

  echo "✔ SSH key uploaded"
}

# -------------------------------------------------
# test ssh
# -------------------------------------------------
test_github_ssh() {
  ssh -T git@github.com || true
}

# -------------------------------------------------
# configure
# -------------------------------------------------
configure_github_ssh() {

  resolve_github_credentials "$@"

  generate_ssh_key
  upload_ssh_key
  test_github_ssh
}
