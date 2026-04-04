# Library for proot-distro: generic install & configure functions
# Intended to be sourced by platform package scripts

# -------------------------------------------------
# Install a proot-distro if not already installed
# -------------------------------------------------
install_proot_distro() {
    local distro="$1"
    local alias="${2:-$distro}"

    # Ensure proot-distro is installed
    pkg_install proot-distro

    if proot-distro list | grep -q "$alias"; then
        echo "✔ $alias already installed"
    else
        echo "==> Installing $distro as $alias"
        proot-distro install --override-alias "$alias" "$distro"
    fi

    echo "✔ $alias installed"
}

# -------------------------------------------------
# Configure a proot-distro: universal user setup
# Optional: execute a distro-specific setup script
# -------------------------------------------------
configure_proot_distro() {
    local alias="$1"
    local user="$2"
    local pass="$3"
    local setup_script="$4"

    echo "==> Configuring $alias"

    if [[ -n "$setup_script" && -f "$setup_script" ]]; then
        # Pass user/pass as environment variables and feed external script safely
        proot-distro login "$alias" -- env user="$user" pass="$pass" bash -s < "$setup_script"
    else
        echo "⚠ No setup script provided, skipping custom setup."
        proot-distro login "$alias"
    fi

    echo ""
    echo "✔ Proot $alias ready"
    echo "Login:"
    echo "  proot-distro login $alias --user $user"
}
