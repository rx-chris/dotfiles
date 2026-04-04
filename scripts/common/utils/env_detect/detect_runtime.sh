
#!/usr/bin/env bash

# load runtime checks
source "$(dirname "${BASH_SOURCE[0]}")/../checks/runtime_checks.sh"

# Returns a string representing the runtime
detect_runtime() {
    local platform="$1"  # optionally pass the detected platform
    if is_docker_runtime; then
        echo "docker"
    elif is_wsl_runtime; then
        echo "wsl"
    elif is_proot_runtime; then
        echo "proot"
    elif [[ "$platform" == "termux" ]]; then
        echo "termux"
    else
        echo "native"
    fi
}
