# MacOs settings
defaults write -g ApplePressAndHoldEnabled -bool false

# Setup syslinks
ln -sfv ~/dotfiles/.config/nvim ~/.config/nvim
ln -sfv ~/dotfiles/.zshrc ~/.zshrc
ln -sfv ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
