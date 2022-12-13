### dot-files

Requires zsh or fish
Lots of config for neovim

To install:

```
cd ~
git clone --recursive https://github.com/danngreen/dot-files.git dot-files

#For zsh:
source dot-files/install.zsh

#For fish:
source dot-files/install.fish
```

The install script will symlink the following files into your home dir, adding a dot before the name:

```
ln -s dot-files/ctags .ctags
ln -s dot-files/fzf.zsh .fzf.zsh
ln -s dot-files/gitignore-global .gitignore-global  
ln -s dot-files/zshrc .zshrc
```

Then it will use `stow` to symlink the nvim dir to ~/.config/nvim

```
cd dot-files
stow -v --target=$HOME/.config/nvim config_nvim
```

If the file exists, it will give an error and not overwrite it.

Make sure to install plugins from nvim the first time you run it

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

