### load package manager functions
source ./pkg-mngr.sh

### Install common packages
COMMON_PKGS="git curl neovim zsh"
pkg_install $COMMON_PKGS


### Install platform-specific packages

# TERMUX_PKGS="clang"
# DEBIAN_PKGS="build-essential"

# if [ -n "$TERMUX_VERSION" ]; then
#     pkg_install $TERMUX_PKGS
# else
#     pkg_install $DEBIAN_PKGS
# fi


### Install Oh My ZSH which also sets zsh as the default shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

