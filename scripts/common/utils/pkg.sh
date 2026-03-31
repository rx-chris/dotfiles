# prevent double loading
[[ -n "${PKG_COMMON_LOADED:-}" ]] && return 0
PKG_COMMON_LOADED=1

# custom package to command mappings for last resort installation check
declare -A PKG_BIN_MAP=(
  [openssh-client]="ssh"
  [neovim]="nvim"
  [nodejs]="node"
)

# check if package is installed
is_pkg_installed() {
  local pkg="$1"
  local cmd mapped

  # package manager check
  if [[ -n "${PKG_CHECK:-}" ]]; then
    printf -v cmd "$PKG_CHECK" "$pkg"
    eval "$cmd" >/dev/null 2>&1 && return 0
  fi

  # direct binary check (default case)
  command -v "$pkg" >/dev/null 2>&1 && return 0

  # mapped binary check (edge cases only)
  mapped="${PKG_BIN_MAP[$pkg]:-}"
  [[ -n "$mapped" ]] && command -v "$mapped" >/dev/null 2>&1 && return 0

  return 1
}

# install package only if missing
pkg_install() {

  local missing=()
  local pkg

  for pkg in "$@"; do
    if ! is_pkg_installed "$pkg"; then
      missing+=("$pkg")
    fi
  done

  [[ ${#missing[@]} -eq 0 ]] && return 0

  echo "==> Installing: ${missing[*]}"
  eval "$PKG_INSTALL ${missing[*]}"
}
