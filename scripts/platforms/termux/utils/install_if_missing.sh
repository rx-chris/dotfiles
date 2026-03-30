#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

source "$SCRIPT_DIR/../../common/utils/cmd_install_if_missing.sh"

# Wrapper function for Ubuntu (using apt)
install_if_missing() {
    cmd_install_if_missing "pkg install -y" "$@"
}

