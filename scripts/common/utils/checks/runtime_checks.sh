#!/usr/bin/env bash

is_docker_runtime() {
  [ -f /.dockerenv ] && return 0
  grep -qaE 'docker|containerd|kubepods' /proc/1/cgroup 2>/dev/null && return 0
  return 1
}

# Function to check if running inside WSL (Ubuntu or other)
# Returns 0 if WSL detected, 1 otherwise
is_wsl_runtime() {
    # Check /proc/version or environment variable
    if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null || [ -n "${WSL_DISTRO_NAME:-}" ]; then
        return 0
    fi

    # Not WSL
    return 1
}

# Returns 0 if inside proot, 1 otherwise
is_proot_runtime() {
    # 1. Check PROOT environment variables
    if [ -n "${PROOT_TMP_DIR:-}" ] || [ -n "${PROOT_NO_SECCOMP:-}" ]; then
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


