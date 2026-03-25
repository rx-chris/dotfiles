#!/usr/bin/env bash

# Function to check if commands exist, and if not, install them using the provided install command
cmd_install_if_missing() {
    local install_cmd=$1
    shift  # Shift arguments to get the list of packages and commands
    local missing_packages=()

    # Define a mapping between commands and their corresponding packages
    declare -A command_to_package=(
        ["ssh"]="openssh-client"  # ssh is provided by the openssh-client package
        ["git"]="git"            # git command from the git package
        ["curl"]="curl"          # curl command from the curl package
        ["wget"]="wget"          # wget command from the wget package
        # Add more command-to-package mappings as needed
    )

    # Loop over the provided commands
    for cmd in "$@"; do
        if ! command -v "$cmd" &>/dev/null; then
            # If the command is missing, look for a mapped package
            if [ -n "${command_to_package[$cmd]}" ]; then
                missing_packages+=("${command_to_package[$cmd]}")  # Add mapped package
            else
                # If no mapping exists, assume the package name is the same as the command
                missing_packages+=("$cmd")
            fi
        fi
    done

    # If there are missing packages, install them in one go
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo "The following packages are missing: ${missing_packages[@]}"
        echo "Installing..."

        # Run the install command with all missing packages
        eval "$install_cmd ${missing_packages[@]}"
    else
        echo "All packages are already installed."
    fi
}


# Wrapper function for Termux (using pkg)
install_if_missing_termux() {
    install_if_missing "pkg install -y" "$@"
}
