# Function to check if running inside Termux
# Returns 0 if Termux detected, 1 otherwise
is_termux() {
    # Typical Termux environment variables and paths
    if [ "$(uname -o 2>/dev/null)" = "Android" ] && [ -n "$PREFIX" ] && [[ "$PREFIX" == /data/data/com.termux* ]]; then
        return 0
    fi

    # Not Termux
    return 1
}
