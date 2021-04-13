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
vim.o.wildmenu =  true
vim.o.wildignore = vim.o.wildignore.."tags,tags.*,build/*"
vim.o.path = ".,,**"

-- Key mappings
local map = vim.api.nvim_set_keymap
local noremap = function(k, c) map('', k, c, {noremap =true}) end
local nnoremap = function(k, c) map('n', k, c, {noremap =true}) end
local tnoremap = function(k, c) map('t', k, c, {noremap =true}) end
local vnoremap = function(k, c) map('v', k, c, {noremap =true}) end

vim.g.mapleader = ','
vim.g.localmapleader = ','
nnoremap('<space>s', '<cmd>:w<CR>')
nnoremap('<space>', '<cmd>noh<CR>')
nnoremap('Y', 'y$')
nnoremap('<leader>w', ':BufferClose<CR>') --w/o barbar it's ':bp <BAR> bd #<CR>'
nnoremap('<M-w>', ':BufferClose<CR>')
nnoremap('<leader>1', '<cmd>BufferGoto 1<CR>')
nnoremap('<leader>2', '<cmd>BufferGoto 2<CR>')
nnoremap('<leader>3', '<cmd>BufferGoto 3<CR>')
nnoremap('<leader>4', '<cmd>BufferGoto 4<CR>')
nnoremap('<leader>5', '<cmd>BufferGoto 5<CR>')
nnoremap('<leader>6', '<cmd>BufferGoto 6<CR>')
nnoremap('<leader>7', '<cmd>BufferGoto 7<CR>')
nnoremap('<leader>8', '<cmd>BufferGoto 8<CR>')
nnoremap('<leader>9', '<cmd>BufferGoto 9<CR>')
nnoremap('<M-Tab>', '<cmd>BufferNext<CR>')
nnoremap('<S-Tab>', '<cmd>BufferPrevious<CR>')
nnoremap('<M-<>', '<cmd>BufferMovePrevious<CR>')
nnoremap('<M->>', '<cmd>BufferMoveNext<CR>')
-- noremap('<M-h>' ,'<cmd>Alternate<CR>')
-- nnoremap('<leader>h', '<C-w>v:Alternate<CR>')
nnoremap('<leader>cd', ':cd %:p:h<CR>:pwd<CR>')

-- Searching/Replacing in current buffer
-- Replace all occurances of word under cursor or visual selection (r = ask for conf., R = don't)
nnoremap('<leader>r', "*Nyiw:%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>")
nnoremap('<leader>R', '*N:%s/\\<<C-r><C-w>\\>//g<Left><Left>')
vnoremap('<leader>r', 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//gc<Left><Left><Left>')
vnoremap('<leader>R', 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//g<Left><Left>')

-- Find Files (by file name)
-- require'plenary.reload'.reload_module('finders') --Todo remove when not developting finders
nnoremap('<leader><space>' ,'<cmd>lua require\'finders\'.buffers()<CR>')
nnoremap('<F3>', '<cmd>lua require\'finders\'.fzf_filename()<CR>')
nnoremap('<F15>', '<cmd>lua require\'finders\'.fzf_filename({all=true})<CR>')

Fzf_conf_dirs = {
	search_dirs = {"~/.local/share/nvim/", "~/.config/nvim/"},
	cwd = "~", all = true
}
nnoremap ('<leader>v<F3>', '<cmd>lua require\'finders\'.fzf_filename(Fzf_conf_dirs)<CR>')
nnoremap ('<leader>p<F3>', '<cmd>lua require\'finders\'.fzf_filename({search_dirs={"~/.config/nvim/"}})<CR>')

Fzf_wiki_conf = {
	search_dirs = {"~/Sync/wiki/"}, all = true,
	layout_strategy = 'center', results_height = 10, width = 0.4
}
nnoremap ('<leader>WW', '<cmd>lua require\'finders\'.fzf_filename(Fzf_wiki_conf)<CR>')

--Just here for when telescope gets buggy (and for opening multiple files):
nnoremap('<leader><F2>' ,'<cmd>Buffers<CR>')
nnoremap('<leader><F3>' ,'<cmd>Files<CR>')
nnoremap ('<leader>v<F15>', '<cmd>lua LS("~/dot-files")<CR>')
nnoremap ('<leader>p<F15>', '<cmd>lua LS("~/.local/share/nvim/")<CR>')

-- Grep Files
nnoremap('<F4>', ':Rg<CR>')
nnoremap('<F16>', ':lua require\'finders\'.fzf_files("<C-R><C-W>",{})<CR>')
vnoremap('<F4>', ':<C-u>lua require\'finders\'.fzf_files("<C-R><C-W>",{})<CR>')

nnoremap('<F8>', ':FloatermToggle<CR>')
tnoremap('<F8>', '<C-\\><C-n>:FloatermToggle<CR>')
noremap('<F9>', ':set list!<CR>')
noremap('<F10>', ':Cope<CR>')
noremap('<F22>', ':ccl<CR>')
noremap('<F11>', ':TagbarToggle<CR>')
noremap('<F23>', ':Dispatch! ctags -R .<CR>')
noremap('<F12>', ':NERDTreeToggle<CR>')

-- Commonly used files
nnoremap('<leader>vv', ':edit ~/.config/nvim/init.lua<CR>')
nnoremap('<leader>vp', ':edit ~/.config/nvim/lua/plugins.lua<CR>')
nnoremap('<leader>va', ':edit ~/.config/nvim/lua/conf/lsp.lua<CR>')
nnoremap('<leader>vcc', ':edit ~/Library/Preferences/clangd/config.yaml<CR>')

-- Copy to clipboard
vnoremap('<M-c>', '"+y')

-- Building
nnoremap('<leader>m', ':wa<CR>:Make<CR>')

-- Display - highlights
vim.cmd[[colorscheme monokai]]
local monokai = require'monokai'
monokai.highlight("TSTemplateArg", {fg = monokai.alternate_blue, bg = monokai.bg})

vim.o.guifont = "Roboto_Mono_Light_for_Powerline:h13"
vim.o.termguicolors = true
vim.o.guicursor="n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1-blinkon150-blinkoff50"
vim.api.nvim_exec([[augroup textyankpost
	autocmd!
	au TextYankPost * lua vim.highlight.on_yank {on_visual = true}
	augroup end]], false)
--require'conf.lualine'
vim.cmd[[
hi BufferCurrent guifg=#080808 guibg=#e6db74
hi BufferCurrentIndex guifg=#080808 guibg=#e6db74
hi BufferCurrentSign guifg=grey guibg=#e6db74
hi BufferCurrentMod guifg=#080808 guibg=#e6db74
hi BufferCurrentTarget guifg=red guibg=#e6db74
hi BufferVisible guifg=#080808 guibg=#808080
hi BufferVisibleIndex guifg=#080808 guibg=#808080
hi BufferVisibleSign guifg=#080808 guibg=#808080
hi BufferVisibleMod guifg=#080808 guibg=#808080
hi BufferVisibleTarget guifg=red guibg=#808080
hi BufferInactive guifg=grey guibg=#080808
hi BufferInactiveIndex guifg=grey guibg=#080808
hi BufferInactiveSign guifg=grey guibg=#080808
hi BufferInactiveMod guifg=grey guibg=#080808
hi BufferInactiveTarget guifg=red guibg=#080808
hi BufferTabpageFill guibg=#080808
hi Visual guibg=#803D3D
hi MatchParen term=bold cterm=bold gui=bold,underline guibg=#446644 guifg=red
]]

--Filetypes
vim.api.nvim_exec([[
augroup filetype_aucmds
	autocmd!
	autocmd BufNewFile,BufRead *.lib set syntax=none
	autocmd BufNewFile,BufRead .clangd set syntax=yaml
augroup END]], false)

--LSP
-- require'plenary.reload'.reload_module('conf.lsp') --Todo remove when not developting finders
require'conf.lsp'
nnoremap('<leader>q', '<cmd>lua require\'telescope.builtin\'.quickfix{}<CR>')

vim.cmd[[
hi! ErrorMsg guifg=#F92622 guibg=#232526 gui=none
hi! WarningMsg guifg=#FD971F guibg=#232526 gui=none
hi! InfoMsg guifg=#E6DB74 guibg=#232526 gui=none 
hi! HintMsg guifg=#A6E22E guibg=#232526 gui=none 
hi! link LspDiagnosticsVirtualTextError ErrorMsg
hi! link LspDiagnosticsVirtualTextWarning WarningMsg
hi! link LspDiagnosticsVirtualTextInformation InfoMsg
hi! link LspDiagnosticsVirtualTextHint HintMsg
hi! LspReferenceText guibg=#433536
hi! TelescopeMatching guifg=red
]]

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
    autocmd DirChanged ~/4ms/stm32/meta-module/H7 source .nvimrc
    autocmd DirChanged ~/4ms/stm32/meta-module/vcv source .nvimrc
  augroup end
]], false)

