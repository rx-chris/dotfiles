# Distro-specific setup for Alpine in proot-distro
# Intended to be sourced inside proot-distro login

echo "==> Running Alpine system setup"

apk update
apk upgrade
apk add sudo bash curl git

# Create user with sudo
adduser -D -s /bin/bash $user
echo "$user:$pass" | chpasswd
adduser $user wheel
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
chmod 0440 /etc/sudoers

echo "User $user created with sudo access on Alpine!"

echo "✔ Alpine setup complete"
