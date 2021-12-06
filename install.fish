echo "Run these commands manually to install fish and chsh to it:"
echo "  macOS (intel): "
echo " 		brew install fish"
echo " 		sudo bash -c 'echo /usr/local/bin/fish >> /etc/shells'"
echo " 		chsh -s /usr/local/bin/fish"
echo ""
echo "  macOS (arm64): "
echo " 		brew install fish"
echo " 		sudo bash -c 'echo /opt/homebrew/bin/fish >> /etc/shells'"
echo " 		chsh -s /opt/homebrew/bin/fish"
echo ""
echo "  ubuntu: "
echo " 		sudo apt install fish"
echo "  	chsh -s /usr/bin/fish"
echo ""

cd $HOME
for dotfile in {ctags,fzf.zsh,gitignore-global}
  ln -s "dot-files/$dotfile" "$HOME/.$dotfile"
end

cd dot-files
mkdir -p $HOME/.config/nvim
stow -v --target=$HOME/.config/nvim config_nvim

mkdir -p $HOME/.config/fish
stow -v --target=$HOME/.config/fish config_fish

