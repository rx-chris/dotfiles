# -------------------------
# Language environments
# -------------------------
# Node.js / nvm
export NVM_DIR="$HOME/.nvm"

lazy_nvm() {
    unset -f node npm npx nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

for cmd in node npm npx nvm; do
    eval "$cmd() { lazy_nvm; $cmd \"\$@\" }"
done

# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Add more languages here as needed
