#!/usr/bin/env bash

# load platform checks
source "$(dirname "${BASH_SOURCE[0]}")/../checks/platform_checks.sh"

# Returns a string representing the platform
detect_platform() {
    if is_termux_platform; then
        echo "termux"
    elif is_ubuntu_platform; then
        echo "ubuntu"
    elif [[ "$(uname -s)" == "Linux" ]]; then
        echo "linux"
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}
