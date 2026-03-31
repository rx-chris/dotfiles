# Node.js / NVM Setup
export NVM_DIR="$HOME/.nvm"

lazy_nvm() {
    unset -f node npm npx nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

for cmd in node npm npx nvm; do
    eval "$cmd() { lazy_nvm; $cmd \"\$@\" }"
done
