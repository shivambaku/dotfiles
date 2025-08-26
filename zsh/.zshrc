# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_CUSTOM=$HOME/.config/zsh/custom
ZSH_THEME="catppuccin"

DISABLE_AUTO_TITLE="true"
DISABLE_LS_COLORS="true"

plugins=(
    git
    vi-mode
    zsh-syntax-highlighting
    you-should-use
    fzf
)

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/fzf-theme.sh

# Aliases
alias n='nvim .'
alias ls='eza'
alias ll='ls -lh --git --icons=always'
alias lla='ll -a'
alias lg="lazygit"
alias oc="opencode"
alias reload="source ~/.zshrc"


