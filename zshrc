ZSH_DISABLE_COMPFIX=true

export ZSH="${HOME}/.oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster" # set by `omz`
DEFAULT_USER="dann"

# CASE_SENSITIVE="true"

HYPHEN_INSENSITIVE="true"
#
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git colored-man-pages colorize pip python brew macos pj zsh-syntax-highlighting)
#disabled_plugins = (zsh-autosuggestions vi-mode zsh-fzf-history-search ) 
#Installation:
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting



KEYTIMEOUT=5

source $ZSH/oh-my-zsh.sh
unsetopt share_history

#prompt
autoload -U zmv 
setopt prompt_subst
#PROMPT='%{$fg[cyan]%}%2~ %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '
#RPROMPT='$(git_prompt_info)'

source ~/dot-files/includes/keys
source ~/dot-files/includes/paths
#source ~/.iterm2_shell_integration.zsh

# Autosuggest:
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888,bg=#404040,bold'
ZSH_AUTOSUGGEST_STRATEGY=(completion match_prev_cmd)

# Highlighting:
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
ZSH_HIGHLIGHT_STYLES[path]=fg=yellow
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=yellow
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

runlazygit () { lazygit }   
zle -N runlazygit
bindkey "^[[18~" runlazygit 

# pj: project jump
PROJECT_PATHS=(~/4ms/stm32 ~/4ms/kicad ~/4ms/esp)

export EDITOR='nvim'
ZVM_VI_EDITOR=nvim
alias v=nvim
alias vi=nvim
alias startidf='. $IDF_PATH/export.sh'
alias stm32prog=~/STM32Cube/STM32CubeProg/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI
alias g=git
#alias python=python3

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/bin/git-subrepo/.rc

