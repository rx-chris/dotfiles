# Function to check if running inside WSL (Ubuntu or other)
# Returns 0 if WSL detected, 1 otherwise
is_wsl() {
    # Check /proc/version or environment variable
    if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
        return 0
    fi

    # Not WSL
    return 1
}
