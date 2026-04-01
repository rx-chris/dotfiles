# -------------------------
# Workflow
# -------------------------
alias ez="nvim ~/.zshrc"
alias sz="source ~/.zshrc"
alias cls="clear"

# -------------------------
# File operations
# -------------------------
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'
alias bat='batcat'

# -------------------------
# eza / ls aliases
# -------------------------
alias ls='eza --icons --group-directories-first'
alias lv='ls -1'
alias la='ls -a'
alias ll='ls -lh'
alias lla='ls -la'
alias lg='ls -l --git'
alias lnew='ls -tl --sort=modified'
alias lsize='ls -l --sort=size'

# -------------------------
# Tree views
# -------------------------
alias lt='ls --tree'
alias lt1='lt --level=1'
alias lt2='lt --level=2'
alias lt3='lt --level=3'
