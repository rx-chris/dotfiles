# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k theme (load FIRST)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# load plugins asysnchronously
zinit ice wait lucid
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# load completion
autoload -Uz compinit && compinit

# ---- Git aliases (OMZ plugin only) ----
zinit snippet OMZP::git

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history search based on current input
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$3NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS'

# ---------------------------------------------------------
# System & Workflow
# ---------------------------------------------------------
alias ez="nvim ~/.zshrc"    # edit zsh configurations
alias sz="source ~/.zshrc"  # reload zsh configurations
alias cls="clear"           # similar to Windows and less characters

# ---------------------------------------------------------
# FILE OPERATIONS (Safety & Feedback)
# ---------------------------------------------------------
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

# ---------------------------------------------------------
# DIRECTORY LISTING (Powered by eza)
# ---------------------------------------------------------
# Core: Replace ls with eza, add icons, and group folders at the top
alias ls='eza --icons --group-directories-first'

# Standard View Variants
alias lv='ls -1'      # Vertical: single column list
alias la='ls -a'      # All: include hidden files
alias ll='ls -lh'     # Long: detailed info with human-readable sizes
alias lla='ls -la'    # Long-All: detailed info including hidden files

# ---------------------------------------------------------
# ADVANCED & SORTED VIEWS
# ---------------------------------------------------------
# Git Status: Shows modified/staged status in the margin
alias lg='ls -l --git'

# Sorted View Variants
alias lnew='ls -tl --sort=modified' # Recent: Sort by newest modified files
alias lsize='ls -l --sort=size' # Size: Sort by largest files

# ---------------------------------------------------------
# TREE VIEWS
# ---------------------------------------------------------
# Base tree command
alias lt='ls --tree'

# Depth-specific tree views
alias lt1='lt --level=1'
alias lt2='lt --level=2'
alias lt3='lt --level=3'
