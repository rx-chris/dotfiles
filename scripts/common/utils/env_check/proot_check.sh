# Returns 0 if inside proot, 1 otherwise
is_in_proot() {
    # 1. Check PROOT environment variables
    if [ -n "$PROOT_TMP_DIR" ] || [ -n "$PROOT_NO_SECCOMP" ]; then
        return 0
    fi

    # 2. Check parent process for 'proot'
    if ps -o ppid= -p $$ | xargs ps -o cmd= -p | grep -q proot; then
        return 0
    fi

    # 3. Check if root filesystem differs from /proc/1/root
    if [ "$(stat -c %d /)" != "$(stat -c %d /proc/1/root)" ]; then
        return 0
    fi

    # 4. Check for overlay mounts
    if grep -q overlay /proc/self/mountinfo; then
        return 0
    fi

    # Not inside proot
    return 1
}
