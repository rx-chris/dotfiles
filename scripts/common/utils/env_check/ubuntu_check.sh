# Function to check if running on Ubuntu
# Returns 0 if Ubuntu, 1 otherwise
is_ubuntu() {
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
