ZSH_DISABLE_COMPFIX=true

export ZSH="${HOME}/.oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="sorin"

# CASE_SENSITIVE="true"

HYPHEN_INSENSITIVE="true"
#
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git colored-man-pages colorize pip python brew osx fd)

source $ZSH/oh-my-zsh.sh
unsetopt share_history

export EDITOR='nvim'

autoload -U zmv
source ~/dot-files/includes/keys
source ~/dot-files/includes/paths
source ~/.iterm2_shell_integration.zsh

alias vi=nvim
alias startidf='source $IDF_PATH/export.sh'
alias stm32prog=~/STM32Cube/STM32CubeProg/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI

alias stmprog=~/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI
