--F5 dirname must be an abs path?
--formatoptions gets cleared/reset by some plugin?

require "plugins"
local vim = vim --one warning here instead of a gazillion warnings everywhere

--Options
vim.o.makeprg = "make -j16"
vim.o.encoding = "UTF-8" -- Do we need this?
vim.o.showmode = false
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.hlsearch = true
vim.wo.number = true
vim.o.hidden = true
vim.o.mouse = "a"
vim.o.splitright = true
vim.o.startofline = false
vim.o.swapfile = false
vim.o.backspace = "indent,eol,start"
vim.o.magic = true -- regular expressions
vim.o.incsearch = true
vim.o.inccommand = "nosplit"
vim.o.listchars = "eol:⏎,tab:| ,trail:*,nbsp:⎵,space:."
vim.o.cmdheight = 1
vim.o.updatetime = 300
vim.o.timeoutlen = 600
vim.wo.signcolumn = "yes"

vim.o.shortmess = vim.o.shortmess .. "c" -- Avoid showing message extra message when using completion
vim.api.nvim_command("set shortmess-=F") -- Allows messages to echo while processing filetypes
vim.o.wildmenu = true
vim.o.wildignore = vim.o.wildignore .. "tags,tags.*,build/*"
vim.o.path = ".,,**"

-- Key Mappings
require "keys"

-- Display
vim.o.guifont = "Inconsolata_Regular_Nerd_Font_Complete_Mono:h13"
vim.o.termguicolors = true
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1-blinkon150-blinkoff50"
vim.api.nvim_exec(
	[[augroup textyankpost
	autocmd!
	au TextYankPost * lua vim.highlight.on_yank {on_visual = true}
	augroup end]],
	false
)

--Filetypes
vim.api.nvim_exec(
	[[
augroup filetype_aucmds
	autocmd!
	autocmd BufNewFile,BufRead *.lib set syntax=none
	autocmd BufNewFile,BufRead .clangd set syntax=yaml
	autocmd FileType qf set nobuflisted
augroup END]],
	false
)

--LSP
-- require'plenary.reload'.reload_module('lsp-conf')
require "lsp-conf"
require "cmp-conf"

vim.api.nvim_exec(
	[[
  augroup init_dot_lua
    autocmd!
    autocmd BufWritePost ~/.config/nvim/init.lua luafile %
    autocmd BufWritePost ~/.config/nvim/keys.lua luafile %
  augroup end
]],
	false
)

vim.cmd[[set exrc]]

--Set these last, some plugin overrides them. TODO: which one?
vim.o.formatoptions = vim.o.formatoptions .. "n" --Format lists
vim.opt.formatoptions:remove "r" -- Don't insert comment leader after pressing <Enter>
vim.opt.formatoptions:remove "o" -- Don't insert comment leader after pressing o or O
