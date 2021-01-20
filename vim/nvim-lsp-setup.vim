lua require("lsp_config")

" Diagnostics
"""""""""""""
nnoremap <leader>f[ <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>f] <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>fp <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>

" Completion
""""""""""""
let g:completion_enable_auto_popup = 0
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_signature = 1
" possible value: "length", "alphabet", "none"
let g:completion_sorting = "alphabet"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_ignore_case = 1
" let g:completion_trigger_character = ['.', '::']
let g:completion_trigger_keyword_length = 3
let g:completion_trigger_on_delete = 0
let g:completion_auto_change_source = 0
let g:completion_timer_cycle = 100 "default value is 80

" complettion sources and chaining
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'file', '<c-n>']},
    \{'mode': '<c-n>'},
    \{'mode': '<c-p>'}
\]
imap <c-j> <Plug>(completion_next_source)
imap <c-k> <Plug>(completion_prev_source)

 " let g:completion_chain_complete_list = {
 "    \ 'lua': [
 "    \    'string': [
 "    \        {'mode': '<c-p>'},
 "    \        {'mode': '<c-n>'}],
 "    \    'func' : [
 "    \        {'complete_items': ['lsp']}],
 "    \    'default': [
 "    \       {'complete_items': ['lsp', 'snippet']},
 "    \       {'mode': '<c-p>'},
 "    \       {'mode': '<c-n>'}],
 "    \],
 "    \ 'default' : {
 "    \   'default': [
 "    \       {'complete_items': ['lsp', 'snippet']},
 "    \       {'mode': '<c-p>'},
 "    \       {'mode': '<c-n>'}],
 "    \   'comment': []
 "    \   }
 "    \}
nnoremap <leader>lsc :echo synIDattr(synID(line('.'), col('.'), 1), "name")<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
" imap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <Tab> to trigger completion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()


" imap <expr> <tab> completion#trigger_completion()

" nmap <tab> <Plug>(completion_smart_tab)
" nmap <s-tab> <Plug>(completion_smart_s_tab)

set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c


" Display
"""""""""
hi LspDiagnosticsVirtualTextError guifg=red gui=bold,italic,underline
hi LspDiagnosticsVirtualTextWarning guifg=orange gui=bold,italic,underline
hi LspDiagnosticsVirtualTextInformation guifg=yellow gui=bold,italic,underline
hi LspDiagnosticsVirtualTextHint guifg=green gui=bold,italic,underline
hi LspReferenceText guibg=#332222 

" Statusline
""""""""""""
if has('nvim')
	"function! LspStatus() abort
	"  if luaeval('#vim.lsp.buf_get_clients() > 0')
	"	return luaeval("require('shorter_statusline').status()")
	"	"return luaeval("require('lsp-status').status()")
	"  endif
	"  return ''
	"endfunction

	"let g:airline_section_x='%{LspStatus()}'
endif


" Debugging/info macros
"""""""""""""""""""""""
"Force stop
nnoremap <leader>lss :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>
"Show debug info
nnoremap <leader>lsI :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
"Show log
nnoremap <leader>lsL :new ~/.local/share/nvim/lsp.log<CR>
" Show completion characters
nnoremap <leader>lsC :lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))

