# Distro-specific setup for Ubuntu in proot-distro
# Intended to be sourced inside proot-distro login

echo "==> Running Ubuntu system setup"

# Update package lists and upgrade installed packages
apt update && apt upgrade -y

# Install sudo if missing
if ! command -v sudo >/dev/null 2>&1; then
    apt install -y sudo
fi

echo "✔ Ubuntu setup complete"
