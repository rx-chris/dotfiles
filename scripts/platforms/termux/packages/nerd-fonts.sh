mkdir -p ~/.termux
cd ~/.termux

# download zip
curl -L -o JetBrainsMono.zip \
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

# unzip
unzip JetBrainsMono.zip

# use best mono font (recommended)
cp JetBrainsMonoNerdFontMono-Regular.ttf font.ttf

# apply font
termux-reload-settings

# test nerd fonts
echo "   "
