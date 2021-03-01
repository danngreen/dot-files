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

Then it will use `stow` to symlink the vim directory

```
cd dot-files
stow vim
```

If the file exists, it will give an error and not overwrite it.

Use plug.vim to install plugins:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim
:PlugInstall
```

Tell git to use the global excludes file like this:

```
git config --global core.excludesfile ~/.gitignore-global
```

