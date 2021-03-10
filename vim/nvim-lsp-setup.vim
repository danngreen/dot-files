lua require("lsp_config")

" Completion
"""""""""""""

" Use <Tab> and <S-Tab> to navigate through popup menu
imap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <Tab> to trigger completion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ compe#complete()

inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
 
" Avoid showing message extra message when using completion
set shortmess+=c


" Display
"""""""""
" hi LspDiagnosticsVirtualTextError guifg=red gui=bold,italic,underline
" hi LspDiagnosticsVirtualTextWarning guifg=orange gui=bold,italic,underline
" hi LspDiagnosticsVirtualTextInformation guifg=yellow gui=bold,italic,underline
" hi LspDiagnosticsVirtualTextHint guifg=green gui=bold,italic,underline


" Debugging/info macros
"""""""""""""""""""""""
"Force stop
nnoremap <leader>lss :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>
"Show debug info
nnoremap <leader>lsI :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
"Show log
nnoremap <leader>lsL :lua vim.api.nvim_command("e "..vim.lsp.get_log_path())<CR>
" Show completion characters
nnoremap <leader>lsC :lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))
" Show current symbol type (useful for completion chain list)
nnoremap <leader>lsc :echo synIDattr(synID(line('.'), col('.'), 1), "name")<CR>
