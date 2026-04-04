# ----------------------------
# Base Config with Stow
# ----------------------------
_base_stow() {
    local action=$1
    local package_name=$2
    local config_dir=${3:-.}
    local target_dir=${4:-$HOME}

    stow --verbose --dir="$config_dir" --target="$target_dir" $action "$package_name"
}

apply_base_config()   { _base_stow ""       "$@"; }   # normal stow
remove_base_config()  { _base_stow --delete "$@"; }   # remove
reapply_base_config() { _base_stow --restow "$@"; }   # restow

# ----------------------------
# Overlay Helpers
# ----------------------------
_overlay_files() {
    local package_name=$1
    local config_dir=${2:-.}

    local overlay_dir="$config_dir/$package_name"

    if [[ ! -d "$overlay_dir" ]]; then
        echo "Overlay '$package_name' does not exist in $overlay_dir"
        return 1
    fi

    find "$overlay_dir" -type f
}

_overlay_symlink_action() {
    local package_name=$1
    local config_dir=${2:-.}
    local target_dir=${3:-$HOME}
    local action=$4   # "apply" or "remove"

    while read -r src; do
        local overlay_dir="$config_dir/$package_name"
        local rel_path=${src#"$overlay_dir/"}   # relative path
        local dest="$target_dir/$rel_path"

        if [[ "$action" == "apply" ]]; then
            mkdir -p "$(dirname "$dest")"
            ln -sf "$src" "$dest"
            echo "Linked $src -> $dest"
        elif [[ "$action" == "remove" ]]; then
            if [[ -L "$dest" ]]; then
                rm "$dest"
                echo "Removed symlink $dest"
            fi
        fi
    done < <(_overlay_files "$package_name" "$config_dir")
}

apply_config_overlay()    { _overlay_symlink_action "$1" "$2" "$3" "apply"; }
remove_config_overlay()   { _overlay_symlink_action "$1" "$2" "$3" "remove"; }
reapply_config_overlay()  { remove_config_overlay "$1" "$2" "$3"; apply_config_overlay "$1" "$2" "$3"; }
