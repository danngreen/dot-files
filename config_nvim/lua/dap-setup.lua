--https://www.reddit.com/r/neovim/comments/silikv/debugging_in_neovim/

print("Loading dap-setup")
require('telescope').load_extension('dap')
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
vim.g.dap_virtual_text = true

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>',{noremap=true})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'v', '<leader>dhv', '<cmd>lua require"dap.ui.variables".visual_hover()<CR>',{noremap=true})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>duf', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",{noremap=true})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dsbr', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dsbm', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>',{noremap=true})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dcc', '<cmd>lua require"telescope".extensions.dap.commands{}<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dco', '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dlb', '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dv', '<cmd>lua require"telescope".extensions.dap.variables{}<CR>',{noremap=true})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>df', '<cmd>lua require"telescope".extensions.dap.frames{}<CR>',{noremap=true})

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dui', '<cmd>lua require"dapui".toggle()<CR>',{noremap=true})

require('dbg.lua')
require('dbg.python')
require('dbg.cpp')
