# Install homebrew 
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade

# Install brew programs
echo "Installing homebrew packages..."
brew bundle install
