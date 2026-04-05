# prevent double loading
[[ -n "${PKG_COMMON_LOADED:-}" ]] && return 0
PKG_COMMON_LOADED=1

# -------------------------------------------------
# Package binary fallbacks (edge cases only)
# -------------------------------------------------
pkg_bin_map_get() {
  local key="$1"

  case "$key" in
    openssh-client) echo "ssh" ;;
    neovim) echo "nvim" ;;
    nodejs) echo "node" ;;
    *) return 1 ;;
  esac
}
# -------------------------------------------------
# Check if package is installed
# -------------------------------------------------
is_pkg_installed() {
  local pkg="$1"
  local mapped=""

  # 1) backend-provided check (preferred if available)
  if declare -F pkg_check_cmd >/dev/null 2>&1; then
    pkg_check_cmd "$pkg" && return 0
  fi

  # 2) direct binary check
  command -v "$pkg" >/dev/null 2>&1 && return 0

  # 3) fallback binary mapping
  mapped="$(pkg_bin_map_get "$pkg" || true)"
  [[ -n "$mapped" ]] && command -v "$mapped" >/dev/null 2>&1 && return 0

  return 1
}
# -------------------------------------------------
# Install packages (delegates to backend)
# -------------------------------------------------
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

  # require backend implementation
  if ! declare -F pkg_install_cmd >/dev/null 2>&1; then
    echo "ERROR: pkg_install_cmd not defined (no backend loaded)" >&2
    return 1
  fi

  pkg_install_cmd "${missing[@]}"
}
