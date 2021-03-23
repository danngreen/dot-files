-- Install packer
require'plugins'

vim.g.python3_host_prog = '/usr/local/bin/python3' --Do we need this?
-- vim.o.rtp = vim.o.rtp..',/usr/local/opt/fzf'

--Options 
vim.o.exrc = true -- .nvimrc for project-specific setup and keymappings
vim.o.secure = true
vim.o.makeprg = 'make -j16'
vim.o.encoding = 'UTF-8' -- Do we need this?
vim.o.showmode = false -- Don't show -- INSERT-- mode, since it's shown in status bar
vim.o.tabstop = 4; vim.bo.tabstop = 4
vim.o.shiftwidth = 4; vim.bo.shiftwidth = 4
vim.o.hlsearch = true
vim.o.number = true
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.splitright = true
vim.o.startofline = false -- Do not jump to first character with page commands.
vim.o.swapfile = false --  Don't use swapfile
vim.o.backspace = "indent,eol,start" --  Makes backspace key more powerful.
vim.o.magic = true -- regular expressions
vim.o.incsearch = true
vim.o.inccommand = 'nosplit'
vim.o.listchars = "eol:⏎,tab:| ,trail:*,nbsp:⎵,space:."
vim.o.cmdheight = 1
vim.o.updatetime = 300
vim.o.signcolumn = 'yes'
vim.o.formatoptions = vim.o.formatoptions.."n"  --Format lists
vim.o.formatoptions = vim.o.formatoptions:gsub("r", "")	 -- Don't insert comment leader after hitting <Enter> in insert mode
vim.o.formatoptions = vim.o.formatoptions:gsub("o", "")	 -- Don't insert comment leader after hitting o or O in normal mode
vim.o.shortmess = vim.o.shortmess.."c"	-- Avoid showing message extra message when using completion

-- Display - highlights
vim.cmd[[syntax enable]] --Is this default on?
vim.cmd[[colorscheme monokai]]
vim.o.termguicolors = true
vim.g.vimsyn_embed = 'lP'
vim.o.guicursor="n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1-blinkon150-blinkoff50"



-- Key mappings
local map = vim.api.nvim_set_keymap
local nmap = function(k, c, opt) map('n', k, c, opt) end
local nnoremap = function(k, c) map('n', k, c, {noremap =true}) end
local vnoremap = function(k, c) map('v', k, c, {noremap =true}) end

vim.g.mapleader = ','
vim.g.localmapleader = ','
nnoremap('<space>', '<cmd>noh<CR>')
nnoremap('Q', '@@')
nnoremap('Y', 'y$')

-- Searching/Replacing in current buffer
-- Replace all occurances of word under cursor or visual selection (r = ask for conf., R = don't)
nnoremap('<leader>r', "*Nyiw:%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>")
nnoremap('<leader>R', '*N:%s/\\<<C-r><C-w>\\>//g<Left><Left>')
vnoremap('<leader>r', 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//gc<Left><Left><Left>')
vnoremap('<leader>R', 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//g<Left><Left>')

-- Find Files (by file name)
nnoremap('<F2>' ,'<cmd>Buffers<CR>') --FZF buffers
nnoremap('<F3>' ,'<cmd>Files<CR>') --FZF find files
nnoremap('<leader><F3>', '<cmd>lua require\'finders\'.find_file()<CR>')
nnoremap('<leader><F15>', '<cmd>lua require\'finders\'.find_all_files()<CR>')
--nnoremap ('<leader>v<F3>', '<cmd>LS ~/dot-files<CR>') --Find files in vim dotfiles
nnoremap ('<leader>v<F3>', '<cmd>lua require\'finders\'.find_dotfiles()<CR>')

