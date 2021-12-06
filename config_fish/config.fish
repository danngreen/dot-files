if status is-interactive
#	set fish_plugins vi-mode
	set fish_pager_color_prefix white --italics
	set fish_pager_color_selected_background --background=666
end

set EDITOR nvim
set VISUAL nvim

alias vi=nvim

fish_add_path /usr/local/opt/make/libexec/gnubin
fish_add_path /usr/local/opt/gnu-sed/libexec/gnubin
fish_add_path $HOME/Library/Python/3.9/bin
fish_add_path $HOME/bin
fish_add_path /usr/local/bin
#fish_add_path $HOME/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin
fish_add_path $HOME/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/4ms/stm32/gcc-arm-none-eabi-10-2021-q1-update/bin/
fish_add_path /opt/homebrew/opt/make/libexec/gnubin
fish_add_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
fish_add_path /opt/homebrew/opt/libtool/libexec/gnubin
fish_add_path /opt/homebrew/opt/curl/bin
fish_add_path $HOME/.cargo/bin
#source $HOME/.cargo/env

set -x IDF_PATH $HOME/4ms/esp/esp-idf-4.3.1

set -x ARM_NONE_EABI_PATH $HOME/4ms/stm32/gcc-arm-none-eabi-10-2021-q1-update/bin/arm-none-eabi

set -gx RACK_DIR $HOME/4ms/vcv/Rack
set -x METAMODULE_ARTWORK_DIR $HOME/4ms/stm32/meta-module/vcv/res
set -x METAMODULE_INFO_DIR $HOME/4ms/stm32/meta-module/shared/CoreModules/info
set -x METAMODULE_PNG_DIR $HOME/4ms/stm32/meta-module/firmware/src/pages/images

set -gx PROJECT_PATHS ~/4ms/stm32 ~/4ms/kicad ~/4ms/esp ~/4ms/vcv

# function fish_key_hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
#     for mode in default insert visual
#         fish_default_key_bindings -M $mode
#     end
#     fish_vi_key_bindings --no-erase insert
# end
# set -g fish_key_bindings fish_key_hybrid_bindings

# set fish_cursor_default block
# set fish_cursor_insert line
# set fish_cursor_replace_one underscore
# set fish_cursor_visual block
# set fish_vi_force_cursor

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

bind -k nul -M insert accept-autosuggestion

set hydro_color_pwd cyan
set hydro_color_git red
set hydro_color_duration grey --italics
set -U fish_color_selection --background 444466
