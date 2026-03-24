# list all files and its contents in a specified directory
list_files() {
  dir="${1:-.}"       # defaults to dir=.       (i.e. current directory)
  pattern="${2:-*}"   # defaults to pattern='*' (i.e. all files)
  depth="${3:-1}"     # defaults to depth=1     (i.e. search only in the current directory)

  # Collect raw content of all files and display with 'bat' or 'cat'
  output=""
  find "$dir" -maxdepth "$depth" -type f -name "$pattern" | sort | while read -r file; do
    echo -e "\n===== $file ====="
    (command -v bat &>/dev/null && bat --style=plain "$file") || cat "$file"
    echo -e "====================\n"

    # Append separator and file name to output for clipboard
    output+="===== $file =====\n"
    output+=$(cat "$file")$'\n'
    output+="====================\n"
  done

  # Copy collected content to clipboard
  echo "$output" | xclip -selection clipboard
}
