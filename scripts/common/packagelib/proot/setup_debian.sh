# Distro-specific setup for Debian in proot-distro
# Intended to be sourced inside proot-distro login

echo "==> Running Debian system setup"

# Update package lists and upgrade installed packages
apt update && apt upgrade -y

# Install sudo if missing
if ! command -v sudo >/dev/null 2>&1; then
    apt install -y sudo
fi

# Optional: install other essential packages
apt install -y curl wget vim

echo "✔ Debian setup complete"
