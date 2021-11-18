cd $HOME
for dotfile in {ctags,fzf.zsh,gitignore-global}
  ln -s "dot-files/$dotfile" "$HOME/.$dotfile"
end
cd dot-files
mkdir -p $HOME/.config/nvim
stow -v --target=$HOME/.config/nvim config_nvim
mkdir -p $HOME/.config/fish
stow -v --target=$HOME/.config/fish config_fish
mkdir -p $HOME/.config/omf
stow -v --target=$HOME/.config/omf config_omf
