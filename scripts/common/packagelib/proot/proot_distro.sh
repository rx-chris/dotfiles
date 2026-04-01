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
    local setup_script="${4:-}"  # optional distro-specific setup script

    echo "==> Configuring $alias"

    proot-distro login "$alias" -- bash -c "
        set -e

        # Universal user setup
        id -u $user >/dev/null 2>&1 || useradd -m -s /bin/bash $user
        echo '$user:$pass' | chpasswd
        usermod -aG sudo $user
        grep -q '$user ALL=(ALL:ALL) ALL' /etc/sudoers || echo '$user ALL=(ALL:ALL) ALL' >> /etc/sudoers

        # Optional distro-specific setup
        if [[ -n '$setup_script' && -f '$setup_script' ]]; then
            source '$setup_script'
        fi

        echo '✔ $alias configured'
    "

    echo ""
    echo "✔ Proot $alias ready"
    echo "Login:"
    echo "  proot-distro login $alias --user $user"
}
