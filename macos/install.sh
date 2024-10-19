# MacOS settings
defaults write -g ApplePressAndHoldEnabled -bool false

# MacOS Keybinds
mkdir -p ~/Library/KeyBindings
cp "$(pwd)DefaultKeyBinding.dict" ~/Library/KeyBindings/DefaultKeyBinding.dict

