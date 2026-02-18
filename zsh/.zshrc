# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set Powerlevel10k Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable the plugins you downloaded
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias nvimcfg="cd ~/.config/nvim/lua/config"
alias nvimplgn="cd ~/.config/nvim/lua/plugins"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
