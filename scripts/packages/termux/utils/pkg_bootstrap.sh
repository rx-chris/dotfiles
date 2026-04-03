# prevent double loading
[[ -n "${PKG_BOOTSTRAP_LOADED:-}" ]] && return 0
PKG_BOOTSTRAP_LOADED=1

set -euo pipefail

PKG_UPDATE="pkg update -y"
PKG_INSTALL="pkg install -y"
PKG_UNINSTALL="pkg uninstall -y"

# must return exit code of 0 (installed) or 1 (not installed)
PKG_CHECK='pkg list-installed | grep -q "^%s/"'

