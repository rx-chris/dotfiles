# Automatically source all modular config files
for rcfile in ~/.zshrc.d/**/*.zsh(.N); do
    source "$rcfile"
done
export PATH=/opt/nvim-linux-arm64/bin:$PATH
