#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# resolve credentials
# -------------------------------------------------
resolve_github_credentials() {

  local cli_user="${1:-}"
  local cli_email="${2:-}"
  local cli_pat="${3:-}"

  GITHUB_USERNAME="${cli_user:-${GITHUB_USERNAME:-${USERNAME:-dev}}}"
  GITHUB_EMAIL="${cli_email:-${GITHUB_EMAIL:-${EMAIL:-dev@example.com}}}"
  GITHUB_PAT="${cli_pat:-${GITHUB_PAT:-}}"

  echo "GitHub user:  $GITHUB_USERNAME"
  echo "GitHub email: $GITHUB_EMAIL"
}

# -------------------------------------------------
# require PAT
# -------------------------------------------------
require_github_pat() {
  [[ -n "${GITHUB_PAT:-}" ]] || {
    echo "❌ GITHUB_PAT is required"
    exit 1
  }
}

# -------------------------------------------------
# GitHub API helper
# -------------------------------------------------
github_api() {
  curl -s \
    -H "Authorization: token $GITHUB_PAT" \
    -H "Content-Type: application/json" \
    "$@"
}
