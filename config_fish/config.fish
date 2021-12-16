if status is-interactive
#	set fish_plugins vi-mode
	set fish_pager_color_prefix black --italics
	set fish_pager_color_selected_background --background=666
end

set EDITOR nvim
set VISUAL nvim

alias vi=nvim

#fish_add_path $HOME/Library/Python/3.9/bin
fish_add_path $HOME/bin
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
#source $HOME/.cargo/env

set BREW_PREFIX (brew --prefix)
fish_add_path $BREW_PREFIX/bin
fish_add_path $BREW_PREFIX/opt/make/libexec/gnubin
fish_add_path $BREW_PREFIX/opt/gnu-sed/libexec/gnubin
fish_add_path $BREW_PREFIX/opt/libtool/libexec/gnubin
fish_add_path $BREW_PREFIX/opt/curl/bin

set -gx IDF_PATH $HOME/4ms/esp/esp-idf-4.3.1

set -gx RACK_DIR $HOME/4ms/vcv/Rack
set -gx METAMODULE_ARTWORK_DIR $HOME/4ms/stm32/meta-module/vcv/res/modules
set -gx METAMODULE_INFO_DIR $HOME/4ms/stm32/meta-module/shared/CoreModules/info
set -gx METAMODULE_PNG_DIR $HOME/4ms/stm32/meta-module/firmware/src/pages/images
set -gx METAMODULE_COREMODULE_DIR $HOME/4ms/stm32/meta-module/shared/CoreModules


function showpath
	echo $fish_user_paths | tr " " "\n" | nl
end

function addpaths
    contains -- $argv $fish_user_paths
       or set -U fish_user_paths $fish_user_paths $argv
    echo "Updated PATH: $PATH"
end

function removepath
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
        echo "Updated PATH: $PATH"
    else
        echo "$argv[1] not found in PATH: $PATH"
    end
end

set fish_greeting

# C-space = accept autosuggestion
bind -k nul -M insert accept-autosuggestion

set hydro_color_pwd cyan
set hydro_color_git red
set hydro_color_duration grey --italics
set -U fish_color_selection --background 444466

source $HOME/.config/fish/local.fish
#set -gx PROJECT_PATHS ~/4ms/stm32 ~/4ms/kicad-pcb ~/4ms/esp ~/4ms/vcv
#set -gx ARM_NONE_EABI_PATH $HOME/4ms/stm32/gcc-arm-none-eabi-10-2021-q1-update/bin/arm-none-eabi
#fish_add_path $HOME/4ms/stm32/gcc-arm-none-eabi-10-2021-q1-update/bin/
