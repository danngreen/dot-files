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
plugins=(git colored-man-pages colorize pip python brew macos fd zsh-autosuggestions zsh-vi-mode)

function zvm_config() {
	ZVM_KEYTIMEOUT=0.2
}

source $ZSH/oh-my-zsh.sh
unsetopt share_history

export EDITOR='nvim'
ZVM_VI_EDITOR=nvim

autoload -U zmv 
PROMPT='%{$fg[cyan]%}%c %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '
RPROMPT=\$(git_prompt_info)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888,bg=#404040,underline'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


source ~/dot-files/includes/keys
source ~/dot-files/includes/paths
source ~/.iterm2_shell_integration.zsh

alias v=nvim
alias vi=nvim
alias startidf='. $IDF_PATH/export.sh'
alias stm32prog=~/STM32Cube/STM32CubeProg/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI
alias g=git

alias luamake=$HOME/bin/lua-language-server/3rd/luamake/luamake
