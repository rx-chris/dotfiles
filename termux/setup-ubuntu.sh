UB_USER="rxchris"
UB_PASS="Termux@123"

proot-distro install ubuntu

proot-distro login ubuntu -- bash -c "
apt update && apt upgrade -y &&

# install sudo
apt install sudo -y &&

# create user
useradd -m -s /bin/bash $UB_USER &&

# set password
echo \"$UB_USER:$UB_PASS\" | chpasswd &&

# give sudo access
usermod -aG sudo $UB_USER &&

echo '$UB_USER ALL=(ALL:ALL) ALL' >> /etc/sudoers &&

echo 'Setup complete: user + sudo installed'
"
