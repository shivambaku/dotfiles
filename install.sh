# MacOS settings
defaults write -g ApplePressAndHoldEnabled -bool false

# MacOS Keybinds
mkdir -p ~/Library/KeyBindings
cp ~/dotfiles/macos/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict

# Setup syslinks
ln -sfv ~/dotfiles/.zshrc ~/.zshrc
ln -snfFv ~/dotfiles/wezterm ~/.config/wezterm


# ln -snfFv ~/dotfiles/alacritty ~/.config/alacritty
# ln -sfv ~/dotfiles/.config/nvim ~/.config/nvim
# ln -sfv ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
#
