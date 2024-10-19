# MacOS settings
defaults write -g ApplePressAndHoldEnabled -bool false

# MacOS Keybinds
mkdir -p ~/Library/KeyBindings
cp ~/dotfiles/macos/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict

# Setup syslinks
ln -snfFv ~/dotfiles/wezterm ~/.config/wezterm
ln -sfv ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sfv ~/dotfiles/zsh/.zprofile ~/.zprofile
ln -sfv ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
ln -snfFv ~/dotfiles/nvim ~/.config/nvim

