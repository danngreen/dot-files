lua <<EOF
local nvim_lsp = require'nvim_lsp'
local buf_set_keymap = vim.api.nvim_buf_set_keymap

local on_attach_vim = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap=true, silent=true }
  buf_set_keymap(bufnr, 'n', 'K', 		'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<C-k>', 	'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',rn', 	'<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',e', 		'<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr', 		'<cmd>lua require\'telescope.builtin\'.lsp_references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',gr', 	'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gd', 		'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gD', 		'<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '1gd', 	'<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gW', 		'<cmd>lua require\'telescope.builtin\'.lsp_workspace_symbols{}<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'g0', 		'<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gI', 		'<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  require'completion'.on_attach(client)
  -- require'diagnostic'.on_attach(client)
end

nvim_lsp.ccls.setup{
    cmd = { "/Users/dann/4ms/ccls/Release/ccls" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
	init_options = {
		highlight = {lsRanges = true}
	},
	on_attach = on_attach_vim
}
EOF
" --Show all diagnostics in quickfix?
"https://github.com/neovim/nvim-lspconfig/issues/69
" do
"   local method = "textDocument/publishDiagnostics"
"   local default_callback = vim.lsp.callbacks[method]
"   vim.lsp.callbacks[method] = function(err, method, result, client_id)
"     default_callback(err, method, result, client_id)
"     if result and result.diagnostics then
"       for _, v in ipairs(result.diagnostics) do
"         v.bufnr = client_id
"         v.lnum = v.range.start.line + 1
"         v.col = v.range.start.character + 1
"         v.text = v.message
"       end
"       vim.lsp.util.set_qflist(result.diagnostics)
"     end
"   end
" end

"diagnostic
let g:space_before_virtual_text = 10 
" let g:diagnostic_trimmed_virtual_text = '20'
" let g:diagnostic_virtual_text_prefix = ' '
" let g:diagnostic_enable_virtual_text = 1
" let g:diagnostic_show_sign = 1
" let g:diagnostic_enable_underline = 1
" let g:diagnostic_auto_popup_while_jump = 1
let g:diagnostic_insert_delay = 0 "If you don't want to show diagnostics while in insert mode, set the following

"completion
let g:completion_enable_auto_popup = 0
"let g:completion_enable_auto_hover = 0
let g:completion_enable_auto_signature = 0
" possible value: "length", "alphabet", "none"
let g:completion_sorting = "length"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_ignore_case = 1
let g:completion_trigger_character = ['.', '::']
"let g:completion_timer_cycle = 200 "default value is 80

"Doesn't work:
lua vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
lua vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
lua vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]

" augroup nvim_lsp_c
" 	autocmd!
" 	autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
" 	autocmd Filetype c setlocal omnifunc=v:lua.vim.lsp.omnifunc
" augroup END

"Force stop
nnoremap <leader>lss :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>:w<CR>:e<CR>
"Show debug info
nnoremap <leader>lsI :lua print(vim.inspect(vim.lsp.buf_get_clients()))
"Show log
nnoremap <leader>lsL :new ~/.local/share/nvim/lsp.log<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <Tab> to trigger completion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

