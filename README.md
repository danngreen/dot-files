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
ln -s dot-files/fzf.sh .fzf.sh
ln -s dot-files/gitignore-global .gitignore-global  
ln -s dot-files/zshrc .zshrc
ln -s dot-files/vimrc .vimrc
ln -s dot-files/vim .vim
```

If the file exists, it will give an error and not overwrite it.

Use Vundle to install the vim plugins:

```
vim
:PluginInstall
```

After that, you may need to compile YouCompleteMe if you haven't before. 

Tell git to use the global excludes file like this:

```
git config --global core.excludesfile ~/.gitignore-global
```

