# prevent double loading
[[ -n "${PKG_BOOTSTRAP_LOADED:-}" ]] && return
PKG_BOOTSTRAP_LOADED=1

pkg_update_cmd() {
  sudo apt update -y
}

# pass package names as arguments
pkg_install_cmd() {
  sudo apt install -y "$@"
}

pkg_uninstall_cmd() {
  sudo apt remove -y "$@"
}

# must return exit code of 0 (installed) or 1 (not installed)
pkg_check_cmd() {
  dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}
