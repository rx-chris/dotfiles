# Automatically source all modular config files
for rcfile in ~/.zshrc.d/**/*.zsh(.N); do
    source "$rcfile"
done
