# Go
export PATH="$(go env GOPATH)/bin:$PATH"

# Python
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Powerlevel10k - Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k - Setup
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# Powerlevel10k - To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Plugins
source $(brew --prefix)/share/zsh-you-should-use/you-should-use.plugin.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# FZF - Keybindings
source <(fzf --zsh)

# Aliases
alias ll='ls -la'
alias proj='cd $(find ~/Documents/Projects -mindepth 1 -maxdepth 2 -type d | fzf)' 

# Git
alias gst="git status"
alias gc="git commit -m"
alias gca="git commit -a -m"
alias ga="git add"
alias gaa="git add --all"
