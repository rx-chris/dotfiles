#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load utitilities
# -------------------------------------------------
# github_api() { ... }
source "$(dirname "${BASH_SOURCE[0]}")/api.sh"

echo "==> GitHub SSH (common logic)"

# -------------------------------------------------
# install dependencies
# -------------------------------------------------
install_github_ssh() {
  pkg_install openssh-client curl jq
}

# -------------------------------------------------
# generate ssh key
# -------------------------------------------------
generate_ssh_key() {
  local email="${1:-}"              # optional, for SSH key comment
  local key_name="${2:-id_ed25519}" # local key filename
  local key_path="$HOME/.ssh/$key_name"

  mkdir -p "$HOME/.ssh"

  if [[ -f "$key_path" ]]; then
    echo "✔ SSH key exists: $key_path"
  else
    echo "==> Generating SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""
  fi

  # Start ssh-agent if needed
  if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
    eval "$(ssh-agent -s)" >/dev/null
  fi

  ssh-add "$key_path" >/dev/null || true

  # Return public key content
  cat "$key_path.pub"
}

# -------------------------------------------------
# upload ssh key to GitHub via helper
# -------------------------------------------------
upload_ssh_key() {
  local token="${1:?GitHub token required}"
  local public_key="${2:?public key required}"
  local title="${3:-$(hostname)-$(date +%s)}"  # GitHub-visible key title

  echo "==> Uploading SSH key to GitHub..."

  # Encode JSON safely
  local json
  json=$(jq -n --arg title "$title" --arg key "$public_key" \
           '{title: $title, key: $key}')

  # Use github_api helper
  if github_api "$token" -X POST "https://api.github.com/user/keys" -d "$json" >/dev/null; then
    echo "✔ SSH key uploaded successfully"
  else
    echo "⚠ Failed to upload SSH key" >&2
    return 1
  fi
}

# -------------------------------------------------
# test SSH connection
# -------------------------------------------------
test_github_ssh() {
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✔ SSH connection to GitHub works"
  else
    echo "⚠ SSH test failed — check your key or GitHub token" >&2
    return 1
  fi
}

# -------------------------------------------------
# configure GitHub SSH
# -------------------------------------------------
configure_github_ssh() {
  local email="${1:-}"                     # optional, for SSH key comment
  local token="${2:?GitHub token required}"    # required for GitHub API
  local key_name="${3:-id_ed25519}"        # local SSH key filename
  local key_title="${4:-$key_name@$(hostname)}" # GitHub-visible title

  local public_key
  public_key=$(generate_ssh_key "$email" "$key_name")

  upload_ssh_key "$token" "$public_key" "$key_title"
  test_github_ssh
}
