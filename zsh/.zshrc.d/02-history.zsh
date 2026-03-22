# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt APPEND_HISTORY        # append instead of overwrite
setopt INC_APPEND_HISTORY    # write commands immediately
setopt SHARE_HISTORY         # share history across terminals
setopt HIST_IGNORE_ALL_DUPS  # remove previous duplicates
setopt HIST_REDUCE_BLANKS    # remove extra spaces
setopt HIST_IGNORE_SPACE     # ignore commands starting with SPACE
setopt HIST_FIND_NO_DUPS     # skip duplicates in reverse search

# Arrow key history search
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
