ln -sfv "$(pwd)/.zshrc" ~/.zshrc
ln -sfv "$(pwd)/.zprofile" ~/.zprofile

mkdir -p ~/.config/zsh
ln -snfFv "$(pwd)/custom" ~/.config/zsh/custom


