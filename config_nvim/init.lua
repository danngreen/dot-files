--F5 dirname must be an abs path?
--fork lualine and apply my minwinwidth changes

require'plugins'

--Options
vim.o.makeprg = 'make -j16'
vim.o.encoding = 'UTF-8' -- Do we need this?
vim.o.showmode = false
vim.o.tabstop = 4; vim.bo.tabstop = 4;
vim.o.shiftwidth = 4; vim.bo.shiftwidth = 4;
vim.o.hlsearch = true
vim.wo.number = true;
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.splitright = true
vim.o.startofline = false
vim.o.swapfile = false
vim.o.backspace = "indent,eol,start"
vim.o.magic = true -- regular expressions
vim.o.incsearch = true
vim.o.inccommand = 'nosplit'
vim.o.listchars = "eol:⏎,tab:| ,trail:*,nbsp:⎵,space:."
vim.o.cmdheight = 1
vim.o.updatetime = 300
vim.o.timeoutlen = 600
vim.wo.signcolumn = 'yes'
vim.o.formatoptions = vim.o.formatoptions.."n"  --Format lists
vim.o.formatoptions = vim.o.formatoptions:gsub("r", "")	 -- Don't insert comment leader after pressing <Enter>
vim.o.formatoptions = vim.o.formatoptions:gsub("o", "")	 -- Don't insert comment leader after pressing o or O
vim.o.shortmess = vim.o.shortmess.."c"	-- Avoid showing message extra message when using completion
vim.api.nvim_command('set shortmess-=F') -- Allows messages to echo while processing filetypes
vim.o.wildmenu =  true
vim.o.wildignore = vim.o.wildignore.."tags,tags.*,build/*"
vim.o.path = ".,,**"

-- Key mappings
local map = vim.api.nvim_set_keymap
local noremap = function(k, c) map('', k, c, {noremap=true, silent=true}) end
local nnoremap = function(k, c) map('n', k, c, {noremap=true}) end
local tnoremap = function(k, c) map('t', k, c, {noremap=true}) end
local vnoremap = function(k, c) map('v', k, c, {noremap=true}) end

vim.g.mapleader = ','
vim.g.localmapleader = ','
nnoremap('<space>s', '<cmd>:w<CR>')
nnoremap('<space>', '<cmd>noh<CR>')
nnoremap('Y', 'y$')
nnoremap('<leader>w', ':bp <BAR> bd #<CR>')
nnoremap('<M-w>', ':bp <BAR> bd #<CR>')
nnoremap('<M-Tab>', '<cmd>:bn<CR>')
nnoremap('<S-Tab>', '<cmd>:bp<CR>')
nnoremap('<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

-- Searching/Replacing in current buffer
-- Replace all occurances of word under cursor or visual selection (r = ask for conf., R = don't)
nnoremap('<leader>r', "*Nyiw:%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>")
nnoremap('<leader>R', '*N:%s/\\<<C-r><C-w>\\>//g<Left><Left>')
vnoremap('<leader>r', 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//gc<Left><Left><Left>')
vnoremap('<leader>R', 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//g<Left><Left>')

-- Find Files (by file name)
-- require'plenary.reload'.reload_module('finders') --Todo remove when not developing finders
nnoremap('<leader><space>' ,'<cmd>lua require\'finders\'.buffers()<CR>')
nnoremap('<F3>', '<cmd>lua require\'finders\'.fzf_filename()<CR>')
nnoremap('<F15>', '<cmd>lua require\'finders\'.fzf_filename({all=true})<CR>')

Fzf_conf_dirs = {
	search_dirs = {"~/.local/share/nvim/", "~/.config/nvim/"},
	cwd = "~", all = true
}
--Plugin dir
nnoremap ('<leader>p<F3>', '<cmd>lua require\'finders\'.fzf_filename(Fzf_conf_dirs)<CR>')
--my nvim conf dir
nnoremap ('<leader>v<F3>', '<cmd>lua require\'finders\'.fzf_filename({search_dirs={"~/.config/nvim/"}})<CR>')

Fzf_wiki_conf = {
	search_dirs = {"~/Sync/wiki/"}, all = true,
	layout_strategy = 'center', layout_config = {height = 15, width = 0.4}
}
nnoremap ('<leader>WW', '<cmd>lua require\'finders\'.fzf_filename(Fzf_wiki_conf)<CR>')

--Just here for when telescope gets buggy (and for opening multiple files):
nnoremap('<leader><F2>' ,'<cmd>Buffers<CR>')
nnoremap('<leader><F3>' ,'<cmd>Files<CR>')

-- Grep Files
nnoremap('<F4>', ':Rg<CR>')
nnoremap('<leader><F4>', ':lua require\'finders\'.fzf_files(vim.fn.input("Search for: "),{})<CR>')
nnoremap('<F16>', ':lua require\'finders\'.fzf_files("<C-R><C-W>",{})<CR>')
vnoremap('<F4>', ':<C-u>lua require\'finders\'.fzf_files("<C-R><C-W>",{})<CR>')

-- Grep in Dir
nnoremap('<F5>', ':lua require\'finders\'.fzf_files("",{search_dirs = {vim.fn.input("Dir: ")}})<CR>')

nnoremap('<F8>', '<cmd>FloatermToggle<CR>')
tnoremap('<F8>', '<C-\\><C-n>:FloatermToggle<CR>')
-- Half-screen float terms:
tnoremap('<F20>h', '<cmd>FloatermUpdate --position=left --width=0.5 --height=1.0<CR>')
tnoremap('<F20>j', '<cmd>FloatermUpdate --position=bottom --width=1.0 --height=0.5<CR>')
tnoremap('<F20>k', '<cmd>FloatermUpdate --position=top --width=1.0 --height=0.5<CR>')
tnoremap('<F20>l', '<cmd>FloatermUpdate --position=right --width=0.5 --height=1.0<CR>')
-- Quarter-screen float terms:
tnoremap('<F20>H', '<cmd>FloatermUpdate --position=left --width=0.25 --height=1.0<CR>')
tnoremap('<F20>J', '<cmd>FloatermUpdate --position=bottom --width=1.0 --height=0.25<CR>')
tnoremap('<F20>K', '<cmd>FloatermUpdate --position=top --width=1.0 --height=0.25<CR>')
tnoremap('<F20>L', '<cmd>FloatermUpdate --position=right --width=0.25 --height=1.0<CR>')
tnoremap('<F20>o', '<cmd>FloatermUpdate --position=topright --width=0.5 --height=0.5<CR>')
--Tiny float terms:
tnoremap('<F20>O', '<cmd>FloatermUpdate --position=topright --width=0.25 --height=0.25<CR>')

noremap('<F9>', ':set list!<CR>')

vim.cmd[[
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        Cope | ccl | vertical botright cope 120
    else
        cclose
    endif
endfunction
]]
noremap('<F10>', ':call ToggleQuickFix()<CR>')

noremap('<F11>', ':TagbarToggle<CR>')
noremap('<F23>', ':Dispatch! ctags -R .<CR>')
noremap('<F12>', ':NERDTreeToggle<CR>')

-- Commonly used files
nnoremap('<leader>vv', ':edit ~/.config/nvim/init.lua<CR>')
nnoremap('<leader>vl', ':edit ~/.config/nvim/lua/conf/lsp.lua<CR>')
nnoremap('<leader>vp', ':edit ~/.config/nvim/lua/plugins.lua<CR>')
nnoremap('<leader>vcc', ':edit ~/Library/Preferences/clangd/config.yaml<CR>')

-- Copy to clipboard
vnoremap('<M-c>', '"+y')

-- Building
nnoremap('<leader>m', ':wa<CR>:Make!<CR>')

-- Display
vim.o.guifont = "Roboto_Mono_Light_for_Powerline:h13"
vim.o.termguicolors = true
vim.o.guicursor="n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1-blinkon150-blinkoff50"
vim.api.nvim_exec([[augroup textyankpost
	autocmd!
	au TextYankPost * lua vim.highlight.on_yank {on_visual = true}
	augroup end]], false)

--Filetypes
vim.api.nvim_exec([[
augroup filetype_aucmds
	autocmd!
	autocmd BufNewFile,BufRead *.lib set syntax=none
	autocmd BufNewFile,BufRead .clangd set syntax=yaml
	autocmd FileType qf set nobuflisted
augroup END]], false)

--LSP
-- require'plenary.reload'.reload_module('conf.lsp') --Todo remove when not developing
require'conf.lsp'

vim.api.nvim_exec([[
  augroup init_dot_lua
    autocmd!
    autocmd BufWritePost ~/.config/nvim/init.lua luafile %
  augroup end
]], false)

--Instead of .nvimrc, we have this... for each and every directory (how convenient!!!)
vim.api.nvim_exec([[
  augroup nvimrc
    autocmd!
    autocmd DirChanged ~/4ms/stm32/meta-module/firmware source .nvimrc
    autocmd DirChanged ~/4ms/stm32/meta-module/vcv source .nvimrc
  augroup end
]], false)
