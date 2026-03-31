SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# -------------------------------------------------
# Load helpers
# -------------------------------------------------
source "$SCRIPT_DIR/env_check/proot_check.sh"
source "$SCRIPT_DIR/env_check/ubuntu_check.sh"
source "$SCRIPT_DIR/env_check/wsl_check.sh"
source "$SCRIPT_DIR/env_check/termux_check.sh"
source "$SCRIPT_DIR/env_check/docker_check.sh"

# -------------------------------------------------
# Detect environment
# -------------------------------------------------
detect_env() {
    ENV_PLATFORM="unknown"
    ENV_RUNTIME="native"

    if is_termux; then
        ENV_PLATFORM="termux"
        ENV_RUNTIME="termux"

    elif is_ubuntu; then
        ENV_PLATFORM="ubuntu"

        if is_wsl; then
            ENV_RUNTIME="wsl"
        elif is_in_proot; then
            ENV_RUNTIME="proot"
        elif is_docker; then
            ENV_RUNTIME="docker"
        fi
    else
        ENV_PLATFORM="linux"

        if is_docker; then
            ENV_RUNTIME="docker"
        fi
    fi

    export ENV_PLATFORM ENV_RUNTIME
}
