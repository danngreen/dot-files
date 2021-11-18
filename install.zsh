setopt extended_glob
for dotfile in ./dot-files/(ctags|fzf.zsh|gitignore-global|zshrc); do
  ln -s "$dotfile" "${HOME}/.${dotfile:t}"
done
cd ./dot-files
mkdir -p $HOME/.config/nvim
stow -v --target=$HOME/.config/nvim config_nvim
