#!/usr/bin/env bash
set -euo pipefail
# -------------------------------------------------
# Load utilities & libraries
# -------------------------------------------------
# load dotfiles environment paths
source "$(dirname "${BASH_SOURCE[0]}")/../utils/env_paths.sh"
# load shell utilities
source "$DOTFILES_COMMON_UTILS/shell.sh"

# -------------------------------------------------
# Neovim Package Library (Minimal / DRY)
# -------------------------------------------------

# Map architecture to binary/archive name
neovim_arch_map() {
    case "$(dpkg --print-architecture)" in
        amd64) echo "nvim-linux-x86_64" ;;
        arm64) echo "nvim-linux-arm64" ;;
        *) return 1 ;;
    esac
}

# Get latest release version from GitHub
neovim_latest_version() {
    curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
        | grep '"tag_name":' \
        | sed -E 's/.*"v([^"]+)".*/\1/'
}

# Get installed Neovim version (normalize by stripping leading 'v')
neovim_installed_version() {
    if command -v nvim >/dev/null 2>&1; then
        nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//'
    else
        echo "0"
    fi
}

# Check if installed version matches latest
neovim_up_to_date() {
    [[ "$(neovim_installed_version)" == "$(neovim_latest_version)" ]]
}

# Download and install Neovim
install_neovim() {
    pkg_install curl tar

    local arch_bin latest installed url
    arch_bin="$(neovim_arch_map)"
    latest="$(neovim_latest_version)"
    installed="$(neovim_installed_version)"

    echo "Latest Neovim: $latest, Installed: $installed"

    if [[ "$installed" == "$latest" ]]; then
        echo "✔ Neovim already up-to-date, skipping download"
        return 0
    fi

    url="https://github.com/neovim/neovim/releases/latest/download/${arch_bin}.tar.gz"
    echo "Downloading $url ..."
    curl -LO "$url"

    sudo rm -rf "/opt/$arch_bin"
    sudo tar -C /opt -xzf "$(basename "$url")"
    rm -f "$(basename "$url")"

    echo "✔ Neovim installed to /opt/$arch_bin"

    # -------------------------------------------------
    # Create/update stable symlink
    # -------------------------------------------------
    echo "🔗 Updating /opt/nvim symlink"

    sudo ln -sfn "/opt/$arch_bin" /opt/nvim

    echo "✔ Symlink set: /opt/nvim -> /opt/$arch_bin"
}

# Configure PATH and sanity check
configure_neovim() {
    local neovim_bin="/opt/nvim/bin"

    echo "searching for $neovim_bin"

    safe_add_to_shell_rc "$neovim_bin" \
        "export PATH=\${PATH:+$neovim_bin:}\$PATH"

    if command -v nvim >/dev/null 2>&1; then
        echo "🧠 neovim: $(nvim --version | head -n1)"
    else
        echo "⚠️ neovim not found in PATH (reload shell required)"
    fi
}
