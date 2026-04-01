# Function to check if running inside Termux
# Returns 0 if Termux detected, 1 otherwise
is_termux_platform() {
    # Typical Termux environment variables and paths
    if [ "$(uname -o 2>/dev/null)" = "Android" ] && [ -n "$PREFIX" ] && [[ "$PREFIX" == /data/data/com.termux* ]]; then
        return 0
    fi

    # Not Termux
    return 1
}

# Function to check if running on Ubuntu
# Returns 0 if Ubuntu, 1 otherwise
is_ubuntu_platform() {
    # Check /etc/os-release for Ubuntu
    if [ -f /etc/os-release ]; then
        if grep -qi "ubuntu" /etc/os-release; then
            return 0
        fi
    fi

    # Fallback: check lsb_release command
    if command -v lsb_release >/dev/null 2>&1; then
        if lsb_release -si | grep -qi "ubuntu"; then
            return 0
        fi
    fi

    # Not Ubuntu
    return 1
}

