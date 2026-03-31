# prevent double loading
[[ -n "${PKG_BOOTSTRAP_LOADED:-}" ]] && return
PKG_BOOTSTRAP_LOADED=1

PKG_UPDATE="sudo apt update -y"
PKG_INSTALL="sudo apt install -y"
PKG_UNINSTALL="sudo apt remove -y"

# must return exit code of 0 (installed) or 1 (not installed)
PKG_CHECK='dpkg-query -W -f="${Status}" "%s" 2>/dev/null | grep -q "install ok installed"'
