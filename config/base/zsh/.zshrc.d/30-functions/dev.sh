dev() {
    # Use argument or current directory
    TARGET_DIR="${1:-$PWD}"
    
    # Make sure it exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Directory '$TARGET_DIR' does not exist."
        return 1
    fi

    # Get folder name for session name
    SESSION_NAME=$(basename "$TARGET_DIR")

    # Check if session exists
    tmux has-session -t "$SESSION_NAME" 2>/dev/null
    if [ $? != 0 ]; then
        # Create session, window 1 = nvim
        tmux new-session -d -s "$SESSION_NAME" -n dev "nvim \"$TARGET_DIR\""
        
        # Create window 2 = terminal
        tmux new-window -t "$SESSION_NAME" -n term -c "$TARGET_DIR"
    fi

    # Attach to session
    tmux attach -t "$SESSION_NAME"
}
