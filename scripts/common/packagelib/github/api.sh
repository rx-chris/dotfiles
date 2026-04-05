#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# GitHub API helper
# -------------------------------------------------
github_api() {
  local token="$1"    # first argument = GitHub personal access token
  shift
  curl -s \
    -H "Authorization: token $token" \
    -H "Content-Type: application/json" \
    "$@"
}
