pkg_update() {
    if [ -n "$TERMUX_VERSION" ]; then
        pkg update -y
    else
        sudo apt update
    fi
}

pkg_install() {
    if [ -n "$TERMUX_VERSION" ]; then
        pkg install -y "$@"
    else
        sudo apt install -y "$@"
    fi
}
pkg_remove() {
    if [ -n "$TERMUX_VERSION" ]; then
        pkg uninstall -y "$@"
    else
        sudo apt remove -y "$@"
    fi
}