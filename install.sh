# MacOS settings
defaults write -g ApplePressAndHoldEnabled -bool false

mkdir -p ~/Library/KeyBindings
cp ~/dotfiles/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict

# Setup syslinks
ln -sfv ~/dotfiles/.zshrc ~/.zshrc

# ln -sfv ~/dotfiles/.config/nvim ~/.config/nvim
# ln -sfv ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf