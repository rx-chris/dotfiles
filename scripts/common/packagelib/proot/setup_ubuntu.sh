# Distro-specific setup for Ubuntu in proot-distro
# Intended to be sourced inside proot-distro login

echo "==> Running Ubuntu system setup"

apt update && apt upgrade -y
apt install -y sudo git curl

# Create user with sudo
useradd -m -s /bin/bash $user
echo "$user:$pass" | chpasswd
usermod -aG sudo $user
echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
chmod 0440 /etc/sudoers

echo "User $user created with sudo access!"

echo "✔ Ubuntu setup complete"
