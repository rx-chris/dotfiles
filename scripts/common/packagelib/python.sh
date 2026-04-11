# -------------------------------------------------
# Python Package Library
# -------------------------------------------------

python_installed() {
    command -v python3 >/dev/null 2>&1
}

python_version() {
    python3 --version 2>/dev/null || echo "not installed"
}

pip_version() {
    pip3 --version 2>/dev/null | cut -d' ' -f1-2 || echo "not installed"
}

install_python() {
    if python_installed; then
        echo "✔ Python already installed: $(python_version)"
        return 0
    fi

    echo "Installing Python..."

    pkg_install python3 python3-pip python3-venv

    echo "✔ Python installed"
}

configure_python() {
    echo "==> Verifying Python setup..."

    if python_installed; then
        echo "🐍 Python: $(python_version)"
    else
        echo "⚠️ python3 not found after installation"
    fi

    if command -v pip3 >/dev/null 2>&1; then
        echo "📦 pip: $(pip_version)"
    else
        echo "⚠️ pip3 not found after installation"
    fi

    echo "✔ Python setup complete"
}
