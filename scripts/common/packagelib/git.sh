#!/usr/bin/env bash
set -euo pipefail

install_git() {
  install_if_missing git
  echo "✔ git installed"
}

configure_git() {

  local cli_name="${1:-}"
  local cli_email="${2:-}"

  GIT_USERNAME="${cli_name:-${GIT_USERNAME:-${USERNAME:-dev}}}"
  GIT_EMAIL="${cli_email:-${GIT_EMAIL:-${EMAIL:-dev@example.com}}}"

  echo "Git user:  $GIT_USERNAME"
  echo "Git email: $GIT_EMAIL"

  local GITCONFIG="$HOME/.gitconfig"
  local LOCAL="$HOME/.gitconfig.local"

  cat > "$LOCAL" <<EOF
[user]
    name = $GIT_USERNAME
    email = $GIT_EMAIL
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
