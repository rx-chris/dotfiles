#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Load shared core + github_api helper
# -------------------------------------------------
source "$(dirname "${BASH_SOURCE[0]}")/api.sh"

echo "==> GitHub SSH (common logic)"

# -------------------------------------------------
# install dependencies
# -------------------------------------------------
install_github_ssh() {
  pkg_install openssh-client curl jq
}

# -------------------------------------------------
# generate ssh key (side-effect only)
# -------------------------------------------------
generate_ssh_key() {
  local email="${1:-}"
  local key_name="${2:-id_ed25519}"
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
}

# -------------------------------------------------
# upload ssh key to GitHub (idempotent)
# -------------------------------------------------
upload_ssh_key() {
  local token="${1:?GitHub token required}"
  local public_key="${2:?public key required}"
  local title="${3:-$(hostname)-$(date +%s)}"

  echo "==> Uploading SSH key to GitHub..."

  # Check if key already exists
  local existing_keys
  existing_keys=$(github_api "$token" "https://api.github.com/user/keys")

  if echo "$existing_keys" | jq -e --arg key "$public_key" '.[] | select(.key == $key)' >/dev/null; then
    echo "✔ SSH key already exists on GitHub"
    return 0
  fi

  # Prepare JSON payload
  local json
  json=$(jq -n --arg title "$title" --arg key "$public_key" \
           '{title: $title, key: $key}')

  # Upload key
  local response
  response=$(github_api "$token" -X POST "https://api.github.com/user/keys" -d "$json")

  # Validate response
  if echo "$response" | jq -e '.id' >/dev/null 2>&1; then
    echo "✔ SSH key uploaded successfully"
  else
    echo "⚠ Failed to upload SSH key" >&2
    echo "Response: $response" >&2
    return 1
  fi
}

# -------------------------------------------------
# test SSH connection (uses specific key)
# -------------------------------------------------
test_github_ssh() {
  local key_name="${1:-id_ed25519}"
  local key_path="$HOME/.ssh/$key_name"

  echo "==> Testing SSH connection..."

  if ssh -i "$key_path" -o StrictHostKeyChecking=no -T git@github.com 2>&1 \
      | grep -q "successfully authenticated"; then
    echo "✔ SSH connection to GitHub works"
  else
    echo "⚠ SSH test failed — SSH may not be using the correct key" >&2
    return 1
  fi
}

# -------------------------------------------------
# configure GitHub SSH (main entrypoint)
# -------------------------------------------------
configure_github_ssh() {
  local email="${1:-}"                         # optional (for key comment)
  local token="${2:?GitHub token required}"    # required
  local key_name="${3:-id_ed25519}"            # local key filename
  local key_title="${4:-$key_name@$(hostname)}" # GitHub key title

  local key_path="$HOME/.ssh/$key_name"
  local pub_key_path="$key_path.pub"

  # Step 1: generate key
  generate_ssh_key "$email" "$key_name"

  # Step 2: read public key
  if [[ ! -f "$pub_key_path" ]]; then
    echo "⚠ Public key not found: $pub_key_path" >&2
    return 1
  fi

  local public_key
  public_key=$(cat "$pub_key_path")

  # Step 3: upload key
  upload_ssh_key "$token" "$public_key" "$key_title"

  # Step 4: test SSH
  test_github_ssh "$key_name"
}
