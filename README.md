### dot-files

Requires zsh

To install:

```
cd ~
git clone --recursive https://github.com/danngreen/dot-files.git dot-files
source dot-files/install
```

The install script will symlink the following files into your home dir, adding a dot before the name:

```
ln -s dot-files/ctags .ctags
ln -s dot-files/fzf.zsh .fzf.zsh
ln -s dot-files/gitignore-global .gitignore-global  
ln -s dot-files/zshrc .zshrc
```

Then it will use `stow` to symlink the vim directory to ~/.vim and the nvim dir to ~/.config/nvim

```
cd dot-files
stow vim
stow -v --target=$HOME/.config/nvim config_nvim
```

If the file exists, it will give an error and not overwrite it.

Make sure to install plugins from nvim the first time you run it

vim:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim
:PlugInstall
```

nvim:
```
nvim
:PackerCompile
:PackerUpdate
```


Tell git to use the global excludes file like this:

```
git config --global core.excludesfile ~/.gitignore-global
```

