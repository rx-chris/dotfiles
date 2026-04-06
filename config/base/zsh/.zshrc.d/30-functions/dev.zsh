dev() {
  # Dependencies
  for cmd in tmux nvim; do
    command -v "$cmd" >/dev/null 2>&1 || {
      echo "❌ $cmd is not installed"
      return 1
    }
  done

  local dir="${1:-.}"
  dir=$(realpath "$dir")
  local session
  session=$(basename "$dir")

  if ! tmux has-session -t "$session" 2>/dev/null; then
    # Start session (shell, not nvim directly)
    tmux new-session -d -s "$session" -c "$dir"

    # Window 0: run nvim inside shell
    tmux send-keys -t "$session:0" "nvim" C-m
    tmux rename-window -t "$session:0" nvim

    # Window 1: shell
    tmux new-window -t "$session" -n shell -c "$dir"
  fi

  # Always focus nvim window
  tmux select-window -t "$session:0"

  tmux attach -t "$session"
}
