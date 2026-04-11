#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Generic shell utilities
# -------------------------------------------------

# Detect current shell (bash, zsh, or fallback)
detect_shell() {
    local shell
    shell="$(basename "$SHELL")"
    case "$shell" in
        bash|zsh) echo "$shell" ;;
        *) echo "fallback" ;;
    esac
}

# Get login shell for the current user
get_login_shell() {
    case "$(uname)" in
        Darwin)
            dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}'
            ;;
        *)
            getent passwd "$USER" | cut -d: -f7
            ;;
    esac
}

# Check if a given shell path is the default login shell
shell_is_default() {
    local target="$1"
    [[ "$(get_login_shell)" == "$target" ]]
}

# -------------------------------------------------
# File helpers
# -------------------------------------------------

# Return true if a file contains a line exactly
file_contains_line() {
    local file="$1"
    local line="$2"
    [[ ! -f "$file" ]] && return 1

    # Escape regex special characters
    local escaped
    escaped=$(printf '%s\n' "$line" | sed 's/[][\\/.*^$]/\\&/g')

    grep -qF "$escaped" "$file"
}

# -------------------------------------------------
# Shell registration helpers
# -------------------------------------------------

# Ensure a shell path is listed in /etc/shells
ensure_shell_registered() {
    local shell_path="$1"

    [[ -f /etc/shells ]] || return 0
    file_contains_line /etc/shells "$shell_path" && return 0

    echo "⚠️ $shell_path not in /etc/shells"
    if command -v sudo >/dev/null; then
        echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
        echo "✅ Added to /etc/shells"
    else
        echo "❌ Cannot update /etc/shells (no sudo)"
        return 1
    fi
}

# Set the default shell for the current user
set_default_shell() {
    local shell_path="$1"

    echo "👉 Changing shell to $shell_path"
    if chsh -s "$shell_path"; then
        echo "✅ Default shell updated"
        echo "🔄 Restart terminal to apply"
        return 0
    fi

    echo "❌ chsh failed"
    echo "👉 Try manually: chsh -s $shell_path"
    return 1
}

# -------------------------------------------------
# Shell RC helpers
# -------------------------------------------------

# Returns top-level RC file and optional modular directory
shell_rc_info() {
    local shell_type rc_file modular_dir
    shell_type="$(detect_shell)"

    case "$shell_type" in
        zsh) rc_file="$HOME/.zshrc"; modular_dir="$HOME/.zshrc.d" ;;
        bash) rc_file="$HOME/.bashrc"; modular_dir="$HOME/.bashrc.d" ;;
        fallback) rc_file="$HOME/.profile"; modular_dir="" ;;
    esac

    printf '%s\n%s\n' "$rc_file" "$modular_dir"
}

# -------------------------------------------------
# Safe append: take regex to detect and snippet to add
# -------------------------------------------------
safe_add_to_shell_rc() {
    local regex="$1"
    local snippet="$2"
    [[ -z "$regex" || -z "$snippet" ]] && { echo "❌ safe_add_to_shell_rc requires regex and snippet"; return 1; }

    local rc_file modular_dir file
    # read rc_file modular_dir < <(shell_rc_info)
    mapfile -t rc_info < <(shell_rc_info)
    rc_file="${rc_info[0]}"
    modular_dir="${rc_info[1]}"
    echo "rc_file: $rc_file"
    echo "modular_dir: $modular_dir"

    # Helper: returns true if regex matches a file
    matches_regex_in_file() {
        local file="$1"
        echo "file: $file"
        echo "regex: $regex"
        [[ -f "$file" ]] || return 1
        grep -qE "$regex" "$file" || return 1
    }

    # Check top-level RC first
    if matches_regex_in_file "$rc_file"; then
        echo "✔ Snippet already present in $rc_file"
        return 0
    fi

    # Check modular dir recursively if it exists
    if [[ -d "$modular_dir" ]]; then
        match_file=$(grep -R -lE "$regex" "$modular_dir" || true)

        if [[ -n "$match_file" ]]; then
            echo "✔ Snippet already present in: $match_file"
            return 0
        fi
    fi    
    # Append snippet if not found anywhere
    echo "$snippet" >> "$rc_file"
    echo "✔ Added snippet to $rc_file"
}
