" lua require('plenary.reload').reload_module("lsp_conf")
" lua require("lsp_conf")

" Debugging/info macros
"""""""""""""""""""""""
""Force stop
"nnoremap <leader>lss :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>
""Show debug info
"nnoremap <leader>lsI :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
""Show log
"nnoremap <leader>lsL :lua vim.api.nvim_command("e "..vim.lsp.get_log_path())<CR>
"" Show completion characters
"nnoremap <leader>lsC :lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))
"" Show current symbol type (useful for completion chain list)
"nnoremap <leader>lsc :echo synIDattr(synID(line('.'), col('.'), 1), "name")<CR>
