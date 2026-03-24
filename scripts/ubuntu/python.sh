run() {
    echo "🔄 Updating package list..."
    sudo apt update

    echo "🐍 Installing Python3..."
    sudo apt install -y python3

    echo "📦 Installing pip..."
    sudo apt install -y python3-pip

    echo "🧪 Installing venv..."
    sudo apt install -y python3-venv

    echo "🔗 Ensuring 'python' points to python3..."
    sudo apt install -y python-is-python3 || true

    echo "✅ Verifying installation..."
    python3 --version
    pip3 --version

    echo "🎉 Python setup complete!"
}
