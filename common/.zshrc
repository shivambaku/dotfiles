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

# Exports
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
export EZA_CONFIG_DIR="$HOME/.config/eza"

# Hotkeys
bindkey '^E' edit-command-line 

# Aliases
alias n='nvim .'
alias ls='eza'
alias ll='ls -lh --git --icons=always'
alias lla='ll -a'
alias lg="lazygit"
alias oc='OPENCODE_EXPERIMENTAL_MARKDOWN=true opencode'
alias reload="source ~/.zshrc"
alias cat="bat"
alias yz="yazi"
