# -------------------------
# Zoxide integration
# -------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# -------------------------
# Enhanced cd function
# -------------------------
cd() {
    if [ $# -eq 0 ]; then
        builtin cd ~                            # no args → home
    elif [ "$1" = "-" ]; then
        builtin cd -                            # cd - → previous
    else
        builtin cd "$1" 2>/dev/null || z "$1"   
    fi
    zoxide add "$PWD" &>/dev/null               # always update database
}
