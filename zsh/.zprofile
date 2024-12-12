# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Go
export PATH="$(go env GOPATH)/bin:$PATH"

# Python
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

