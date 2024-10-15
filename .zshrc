export EDITOR="code -w"

export PATH="$(go env GOPATH)/bin:/opt/homebrew/opt/python/libexec/bin:/Users/shivambaku/.cargo/bin:$PATH" 

eval "$(zoxide init zsh)"

[ -f "/Users/shivambaku/.ghcup/env" ] && source "/Users/shivambaku/.ghcup/env" # ghcup-env
