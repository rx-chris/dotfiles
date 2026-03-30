#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"

echo "==> Python setup"

# -------------------------------------------------
# Core Python
# -------------------------------------------------
install_if_missing python3
install_if_missing python3-pip

# -------------------------------------------------
# Useful tooling
# -------------------------------------------------
install_if_missing python3-venv

echo "✔ Python setup complete"
