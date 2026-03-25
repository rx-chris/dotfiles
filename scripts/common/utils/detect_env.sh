#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Source all helper scripts
source "$SCRIPT_DIR/utils/proot_check.sh"
source "$SCRIPT_DIR/utils/ubuntu_check.sh"
source "$SCRIPT_DIR/utils/wsl_check.sh"
source "$SCRIPT_DIR/utils/termux_check.sh"

# Main environment detection function
detect_env() {
    local env="unknown"

    if is_termux; then
        env="termux"
    elif is_wsl; then
        env="wsl-ubuntu"
    elif is_ubuntu; then
        if is_in_proot; then
            env="proot-ubuntu"
        else
            env="ubuntu"
        fi
    else
        env="linux"
    fi

    echo "$env"
}
