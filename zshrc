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
plugins=(git colored-man-pages colorize pip python brew macos fd pj zsh-syntax-highlighting) 
#disabled: zsh-autosuggestions vi-mode

KEYTIMEOUT=5
# VI_MODE_SET_CURSOR=true
# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

source $ZSH/oh-my-zsh.sh
unsetopt share_history

#prompt
autoload -U zmv 
setopt prompt_subst
PROMPT='%{$fg[cyan]%}%2~ %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '
RPROMPT='$(git_prompt_info)'

source ~/dot-files/includes/keys
source ~/dot-files/includes/paths
#source ~/.iterm2_shell_integration.zsh

# Autosuggest:
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888,bg=#404040,bold'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Highlighting:
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
ZSH_HIGHLIGHT_STYLES[path]=fg=yellow
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=yellow
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

# pj: project jump
PROJECT_PATHS=(~/4ms/stm32 ~/4ms/kicad-pcb ~/4ms/esp)


export EDITOR='nvim'
ZVM_VI_EDITOR=nvim
alias v=nvim
alias vi=nvim
alias startidf='. $IDF_PATH/export.sh'
alias stm32prog=~/STM32Cube/STM32CubeProg/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI
alias g=git
alias luamake=$HOME/bin/lua-language-server/3rd/luamake/luamake
