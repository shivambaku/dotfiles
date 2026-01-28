# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_CUSTOM=$HOME/.config/zsh/custom
ZSH_THEME="catppuccin"
DISABLE_AUTO_TITLE="true"
DISABLE_LS_COLORS="true"
VI_MODE_SET_CURSOR=false
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=false
KEYTIMEOUT=1

plugins=(
    git
    vi-mode
    zsh-syntax-highlighting
    zsh-you-should-use
    fzf
)

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/fzf-theme.sh

# Clear vi-mode right prompt (mode indicator handled by theme)
RPS1=''
RPROMPT=''

# Hotkeys
bindkey '^E' edit-command-line 

# Exports
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"

# Aliases
alias n='nvim .'
alias ls='eza'
alias ll='ls -lh --git --icons=always'
alias lla='ll -a'
alias lg="lazygit"
alias oc="opencode"
alias reload="source ~/.zshrc"


