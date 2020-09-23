lua require("lsp_config")

"diagnostic
let g:space_before_virtual_text = 5 
let g:diagnostic_trimmed_virtual_text = '40'
" let g:diagnostic_virtual_text_prefix = '<'
let g:diagnostic_enable_virtual_text = 1
" let g:diagnostic_show_sign = 1
let g:diagnostic_enable_underline = 1
 let g:diagnostic_auto_popup_while_jump = 1
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

