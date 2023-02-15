-- Key mappings
local map = vim.api.nvim_set_keymap
local noremap = function(k, c)
	map("", k, c, { noremap = true, silent = true })
end
local nnoremap = function(k, c)
	map("n", k, c, { noremap = true })
end
local tnoremap = function(k, c)
	map("t", k, c, { noremap = true })
end
local vnoremap = function(k, c)
	map("v", k, c, { noremap = true })
end

vim.g.mapleader = ","
vim.g.localmapleader = ","
nnoremap("<space>", "<cmd>noh<CR>")
-- nnoremap("Y", "y$")
nnoremap("<leader>w", ":bp <BAR> bd #<CR>")
nnoremap("<M-w>", ":bp <BAR> bd #<CR>")
nnoremap("<M-Tab>", "<cmd>:bp<CR>")
nnoremap("<S-Tab>", "<cmd>:bn<CR>")
nnoremap("<leader><Tab>", "<cmd>:bn<CR>")
nnoremap("<leader>cd", ":cd %:p:h<CR>:pwd<CR>")

-- Searching/Replacing in current buffer
-- Replace all occurances of word under cursor or visual selection (r = ask for conf., R = don't)
nnoremap("<leader>r", "*Nyiw:%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>")
nnoremap("<leader>R", "*N:%s/\\<<C-r><C-w>\\>//g<Left><Left>")
vnoremap("<leader>r", 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//gc<Left><Left><Left>')
vnoremap("<leader>R", 'y:%s/\\V<C-R>=escape(@",\'/\\\')<CR>//g<Left><Left>')

-- Find Files (by file name)
nnoremap("<leader><leader><space>",
	'<cmd>lua require"fzf-lua".resume({winopts={height=0.6, width=0.4, preview={vertical="up:25%"}}})<CR>')
nnoremap("<leader><space>",
	'<cmd>lua require"fzf-lua".buffers({winopts={height=0.6, width=0.4, preview={hidden="hidden"}}})<CR>')
nnoremap("<leader>2",
	'<cmd>lua require"fzf-lua".buffers({winopts={height=0.6, width=0.4, preview={hidden="hidden"}}})<CR>')
nnoremap("<F2>", '<cmd>lua require"fzf-lua".buffers({winopts={height=0.6, width=0.4, preview={hidden="hidden"}}})<CR>')

nnoremap("<F3>", '<cmd>lua require"fzf-lua".files()<CR>')
nnoremap("<leader>3", '<cmd>lua require"fzf-lua".files()<CR>')

nnoremap("<F15>", '<cmd>lua require"fzf-lua".files({cmd=require"fzf-lua-conf".find_all_files_cmd})<CR>')
nnoremap("<leader>#", '<cmd>lua require"fzf-lua".files({cmd=require"fzf-lua-conf".find_all_files_cmd})<CR>')

Plugin_dir_conf = { cwd = "~/.local/share/nvim/", all = true }
Nvim_conf_dir_conf = { cwd = "~/.config/nvim/", all = true }
Wiki_conf = {
	cwd = "~/Sync/wiki/",
	winopts = { win_height = 0.4, win_width = 0.2, fullscreen = false },
	preview_opts = "hidden"
}
--Plugin dir
nnoremap("<leader>p<F3>", '<cmd>lua require"fzf-lua".files(Plugin_dir_conf)<CR>')
nnoremap("<leader>p3", '<cmd>lua require"fzf-lua".files(Plugin_dir_conf)<CR>')
nnoremap("<leader>p<F4>", '<cmd>lua require"fzf-lua".grep(Plugin_dir_conf)<CR>')
nnoremap("<leader>p4", '<cmd>lua require"fzf-lua".grep(Plugin_dir_conf)<CR>')
--my nvim conf dir
nnoremap("<leader>v<F3>", '<cmd>lua require"fzf-lua".files(Nvim_conf_dir_conf)<CR>')
nnoremap("<leader>v3", '<cmd>lua require"fzf-lua".files(Nvim_conf_dir_conf)<CR>')
nnoremap("<leader>v<F4>", '<cmd>lua require"fzf-lua".grep(Nvim_conf_dir_conf)<CR>')
nnoremap("<leader>v4", '<cmd>lua require"fzf-lua".grep(Nvim_conf_dir_conf)<CR>')
--wiki dir
nnoremap("<leader>WW", '<cmd>lua require"fzf-lua".files(Wiki_conf)<CR>')

-- F4: Find in contents of files

-- F4: Find in contents of files
-- S-F4 or F4 in visual mode: initial filter for find word under cursor or selected word
-- leader F4: prompt for initial filter
-- leader S-F4: live grep (using skim). Toggle fzf syntax or regex (.*, etc) with ctrl-q
-- F5: Find in a dir (prompt)
nnoremap("<F4>", ':lua require"fzf-lua".grep({fzf_cli_args="--nth 2..", search=""})<CR>') --use "--with-nth 2.." to not search filename
nnoremap("<leader>4", ':lua require"fzf-lua".grep({fzf_cli_args="--nth 2..", search=""})<CR>') --use "--with-nth 2.." to not search filename
nnoremap("<leader><F4>", ':lua require"fzf-lua".grep({search=""})<CR>')

nnoremap("<F16>", ':lua require"fzf-lua".grep_cword()<CR>') --({search="<C-R><C-W>"})<CR>')
nnoremap("<leader>$", ':lua require"fzf-lua".grep_cword()<CR>')

vnoremap("<F4>", ':<C-u>lua require"fzf-lua".grep_visual()<CR>') --({search="<C-R><C-W>"})<CR>')
vnoremap("<leader>4", ':<C-u>lua require"fzf-lua".grep_visual()<CR>') --({search="<C-R><C-W>"})<CR>')

-- nnoremap("<leader><F4>", ':lua require"fzf-lua".grep()<CR>')
-- nnoremap("<leader><F16>", ':lua require"fzf-lua".live_grep_native({fzf_cli_args="--nth 2.."})<CR>')
-- nnoremap("<leader><leader><F16>", ':lua require"fzf-lua".live_grep_resume()<CR>')

-- Grep in Dir
--nnoremap('<F5>', ':lua require\'finders\'.fzf_files("",{search_dirs = {vim.fn.input("Dir: ")}})<CR>')
nnoremap("<F5>", ':lua require"fzf-lua".grep({search="", cwd = vim.fn.input("Dir: ")})<CR>')
nnoremap("<leader><F5>", ':lua require"fzf-lua".files({cwd = vim.fn.input("Dir: ")})<CR>')
nnoremap("<F17>", ':lua require"fzf-lua".grep_cword({cwd = vim.fn.input("Dir: ")})<CR>')

nnoremap("<F8>", "<cmd>FloatermToggle<CR>")
tnoremap("<F8>", "<C-\\><C-n>:FloatermToggle<CR>")
-- Half-screen float terms:
tnoremap("<F20>h", "<cmd>FloatermUpdate --position=left --width=0.5 --height=1.0<CR>")
tnoremap("<F20>j", "<cmd>FloatermUpdate --position=bottom --width=1.0 --height=0.5<CR>")
tnoremap("<F20>k", "<cmd>FloatermUpdate --position=top --width=1.0 --height=0.5<CR>")
tnoremap("<F20>l", "<cmd>FloatermUpdate --position=right --width=0.5 --height=1.0<CR>")
-- Quarter-screen float terms:
tnoremap("<F20>H", "<cmd>FloatermUpdate --position=left --width=0.25 --height=1.0<CR>")
tnoremap("<F20>J", "<cmd>FloatermUpdate --position=bottom --width=1.0 --height=0.25<CR>")
tnoremap("<F20>K", "<cmd>FloatermUpdate --position=top --width=1.0 --height=0.25<CR>")
tnoremap("<F20>L", "<cmd>FloatermUpdate --position=right --width=0.25 --height=1.0<CR>")
tnoremap("<F20>o", "<cmd>FloatermUpdate --position=topright --width=0.5 --height=0.5<CR>")
--Tiny float terms:
tnoremap("<F20>O", "<cmd>FloatermUpdate --position=topright --width=0.25 --height=0.25<CR>")
--Fullscreen
tnoremap("<F20><F20>", "<cmd>FloatermUpdate --position=right --width=1.0 --height=1.0<CR>")

noremap("<F9>", ":set list!<CR>")

vim.cmd [[
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        Cope | ccl | vertical botright cope 120
    else
        cclose
    endif
endfunction
]]

noremap("<F10>", ":TagbarToggle<CR>")
noremap("<F11>", ":call ToggleQuickFix()<CR>")
noremap("<F23>", ":Dispatch! ctags -R .<CR>")
-- noremap("<F12>", ":NERDTreeToggle<CR>")
noremap("<F12>", "<cmd>Neotree toggle<CR>")

nnoremap("<leader><leader>", ":w<CR>")
-- Commonly used files
nnoremap("<leader>vv", ":edit ~/.config/nvim/init.lua<CR>")
nnoremap("<leader>vl", ":edit ~/.config/nvim/lua/lsp-conf.lua<CR>")
nnoremap("<leader>vk", ":edit ~/.config/nvim/lua/keys.lua<CR>")
nnoremap("<leader>vp", ":edit ~/.config/nvim/lua/plugins.lua<CR>")
nnoremap("<leader>vh", ":edit ~/.config/nvim/lua/custom-hi.lua<CR>")
nnoremap("<leader>vcc", ":edit ~/Library/Preferences/clangd/config.yaml<CR>")

-- Copy to clipboard
vnoremap("<M-c>", '"+y')

-- Building
nnoremap("<leader>m", ":wa<CR>:Make!<CR>")

nnoremap("<F7>", "<cmd>FloatermNew --height=1.0 --width=1.0 --autoclose=1 lazygit<CR>")
nnoremap("<F19>", "<cmd>Git<CR>")

--- Debugging
nnoremap("<leader>dl", "<cmd>call vimspector#Launch()<cr>")
nnoremap("<leader>dr", "<cmd>call vimspector#Reset()<cr>")
nnoremap("<leader>dn", "<cmd>call vimspector#StepInto()<cr>")
nnoremap("<leader>ds", "<cmd>call vimspector#StepOver()<cr>")
nnoremap("<leader>do", "<cmd>call vimspector#StepOut()<cr>")
nnoremap("<leader>db", "<cmd>call vimspector#ToggleBreakpoint()<cr>")
nnoremap("<leader>dw", "<cmd>call vimspector#AddWatch()<cr>")
nnoremap("<leader>de", "<cmd>call vimspector#Evaluate()<cr>")
