# Distro-specific setup for Alpine in proot-distro
# Intended to be sourced inside proot-distro login

echo "==> Running Alpine system setup"

# Update package index
apk update

# Install sudo and shadow (needed for user management)
apk add sudo shadow bash curl wget vim

# Ensure bash exists for user shell
if ! command -v bash >/dev/null 2>&1; then
    echo "Warning: bash not installed, default shell may be /bin/sh"
fi

echo "✔ Alpine setup complete"
