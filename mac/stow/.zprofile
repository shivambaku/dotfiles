# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# UV
export PATH="$HOME/.local/bin:$PATH"

# Python
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"

# Postgres
export PATH="$(brew --prefix)/opt/postgresql@17/bin:$PATH"

# Colima
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock"

