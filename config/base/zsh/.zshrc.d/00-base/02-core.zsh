# zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Completion plugins
zinit light zsh-users/zsh-completions
zinit snippet OMZP::git
zinit light Aloxaf/fzf-tab

# Async plugins
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# Initialize completion
autoload -Uz compinit
compinit -C

# Enable caching for all Zsh completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# fzf-tab cd preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath'

# Restore previous directory state
zinit cdreplay -q
