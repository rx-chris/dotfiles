# prevent double loading
[[ -n "${PKG_BOOTSTRAP_LOADED:-}" ]] && return 0
PKG_BOOTSTRAP_LOADED=1

pkg_update_cmd() {
  pkg update -y
}

# pass package names as arguments
pkg_install_cmd() {
  pkg install -y "$@"
}

pkg_uninstall_cmd() {
  pkg uninstall -y "$@"
}

pkg_check_cmd() {
  local pkg="$1"

  pkg list-installed | grep -q "^${pkg}/"
}
