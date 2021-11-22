# if status is-interactive
# end
set fish_plugins vi-mode
set fish_pager_color_prefix red --italics
set fish_pager_color_selected_background --background=666

set EDITOR nvim
set VISUAL nvim

alias vi=nvim

fish_add_path /usr/local/opt/make/libexec/gnubin
fish_add_path $HOME/4ms/stm32/gcc-arm-none-eabi-10-2020-q4-major/bin
fish_add_path /usr/local/opt/gnu-sed/libexec/gnubin
fish_add_path $HOME/Library/Python/3.9/bin
fish_add_path $HOME/bin
fish_add_path /usr/local/bin
fish_add_path $HOME/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/opt/llvm/bin

set -x IDF_PATH $HOME/4ms/esp/esp-idf_4.0.1

set -x ARM_NONE_EABI_PATH $HOME/4ms/stm32/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi

set -x RACK_DIR $HOME/4ms/vcv/Rack
set -x METAMODULE_ARTWORK_DIR $HOME/4ms/stm32/meta-module/vcv/res
set -x METAMODULE_INFO_DIR $HOME/4ms/stm32/meta-module/shared/CoreModules/info
set -x METAMODULE_PNG_DIR $HOME/4ms/stm32/meta-module/firmware/src/pages/images

function fish_key_hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase insert
end
set -g fish_key_bindings fish_key_hybrid_bindings

set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
set fish_vi_force_cursor

function cd..
	cd ..
end

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

bind '$' bind_dollar
bind '!' bind_bang
