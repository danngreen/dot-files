### dot-files

Requires zsh

To install:

```
cd ~
git clone https://github.com/danngreen/dot-files.git dot-files
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

If the file exists, it will give an error.

You might need to tell git to use the global excludes file

```
git config --global core.excludesfile ~/.gitignore-global
```

