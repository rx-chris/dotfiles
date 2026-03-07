#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Git + GitHub SSH Setup (Ubuntu)
# -----------------------------

source "$HOME/dotfiles/scripts/common.sh"

SSH_DIR="$HOME/.ssh"
GITHUB_KEY="$SSH_DIR/id_ed25519_github"

log_info "Starting Git + GitHub SSH setup"

# ---- 1. Install dependencies ----
install_package git openssh-client

# ---- 2. Prompt user for Git username ----
read -p "Enter your Git username: " GIT_USERNAME

# ---- 3. Prompt user for Git email with validation ----
while true; do
    read -p "Enter your Git email: " GIT_EMAIL
    if [[ "$GIT_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        break
    else
        log_warn "Invalid email format. Please enter a valid email."
    fi
done

# ---- 4. Configure Git globally ----
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.autocrlf input
git config --global pull.rebase false
log_success "Git configured with username: $GIT_USERNAME and email: $GIT_EMAIL"

# ---- 5. Ensure ~/.ssh exists ----
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# ---- 6. Generate SSH key if missing ----
if [ ! -f "$GITHUB_KEY" ]; then
    log_info "Generating a new SSH key for GitHub..."
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$GITHUB_KEY" -N ""
    log_success "SSH key generated at $GITHUB_KEY"
else
    log_info "GitHub SSH key already exists: $GITHUB_KEY"
fi

# ---- 7. Start ssh-agent if not running ----
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    log_info "Starting ssh-agent..."
    eval "$(ssh-agent -s)"
fi

# ---- 8. Add key to ssh-agent ----
if ! ssh-add -l | grep -q "$GITHUB_KEY"; then
    log_info "Adding GitHub key to ssh-agent..."
    ssh-add "$GITHUB_KEY"
    log_success "GitHub key added to ssh-agent"
else
    log_info "GitHub key already added to ssh-agent"
fi

# ---- 9. Create SSH config entry for GitHub ----
SSH_CONFIG="$SSH_DIR/config"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
    cat >> "$SSH_CONFIG" <<EOL

Host github.com
    HostName github.com
    User git
    IdentityFile $GITHUB_KEY
    AddKeysToAgent yes
EOL
    chmod 600 "$SSH_CONFIG"
    log_success "SSH config for GitHub created at $SSH_CONFIG"
else
    log_info "SSH config for GitHub already exists"
fi

# ---- 10. Show public key for user to add to GitHub ----
echo "=================================================================="
echo "Copy the following SSH public key and add it to GitHub:"
echo "Settings → SSH and GPG keys → New SSH key → Paste the key"
echo "=================================================================="
cat "${GITHUB_KEY}.pub"
echo "=================================================================="
read -p "Press Enter after you have added the key to GitHub..."

# ---- 11. Test SSH connection ----
log_info "Testing SSH connection to GitHub..."
ssh -T git@github.com
