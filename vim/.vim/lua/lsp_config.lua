--https://github.com/nvim-lua/completion-nvim/wiki/per-server-setup-by-lua
local nvim_lsp = require'nvim_lsp'
local util = require'nvim_lsp/util'
local lsp_status = require'lsp-status'
-- local config = require'nvim_lsp/config'
local buf_set_keymap = vim.api.nvim_buf_set_keymap

-- Registers the progress callback
lsp_status.register_progress()
-- Set default client capabilities plus window/workDoneProgress
--config.capabilities = vim.tbl_extend('keep', config.capabilities or {}, lsp_status.capabilities)

-- Attach: set keys, set omnifunc, attach to lsp plugins
local on_attach_vim = function(client, bufnr)
  print("LSP started");

  local opts = { noremap=true, silent=true }
  buf_set_keymap(bufnr, 'n', 'K', 			'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>rn', 	'<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>e', 	'<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>gr',	'<cmd>lua require\'telescope.builtin\'.lsp_references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr',  		'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gd', 			'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gD', 	 		'<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>gw',	'<cmd>lua require\'telescope.builtin\'.lsp_workspace_symbols()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gW',  		'<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'g0', 			'<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>ff', 	'<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  buf_set_keymap(bufnr, 'n', '<M-h>',		'<cmd>ClangdSwitchSourceHeader<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>h', 	'<cmd>ClangdSwitchSourceHeaderVSplit<CR>', opts)

  buf_set_keymap(bufnr, 'n', 'gF', 			'<cmd>lua vim.lsp.buf.type_definition()<CR>', opts) --not supported by clangd
  buf_set_keymap(bufnr, 'n', 'gI', 			'<cmd>lua vim.lsp.buf.implementation()<CR>', opts) --not supported by clangd

  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
  require'lsp-status'.on_attach(client)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end


-- Clang

local function switch_source_header_splitcmd(bufnr, splitcmd)
  bufnr = util.validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then error(tostring(err)) end
    if not result then print ("Corresponding file can’t be determined") return end
    vim.api.nvim_command(splitcmd..' '..vim.uri_to_fname(result))
  end)
end
nvim_lsp.clangd.switch_source_header_splitcmd = switch_source_header_splitcmd

nvim_lsp.clangd.setup {
  cmd = {
	  "/Users/dann/bin/clangd_11.0.0-rc1/bin/clangd",
      "--background-index",
      "--log=verbose",
	  -- "--clang-tidy",
      "--cross-file-rename",
      "--suggest-missing-includes",
      --"--all-scopes-completion",
	  "--completion-style=bundled",
	  "--query-driver=/Users/dann/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-*",
	  "--query-driver=/usr/local/Cellar/arm-none-eabi-gcc/**/bin/arm-none-eabi-*",
	  "--pch-storage=disk",
	  "--enable-config"
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
  root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  on_attach = on_attach_vim,
  callbacks = lsp_status.extensions.clangd.setup(),
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false
        }
      }
    }
  },

  init_options = {clangdFileStatus = true},
  commands = {
	ClangdSwitchSourceHeader = {
	  function()
		switch_source_header_splitcmd(0, "edit")
	  end;
	  description = "Open source/header in a new vsplit";
	},
	ClangdSwitchSourceHeaderVSplit = {
	  function()
		switch_source_header_splitcmd(0, "vsplit")
	  end;
	  description = "Open source/header in a new vsplit";
	},
	ClangdSwitchSourceHeaderSplit = {
	  function()
		switch_source_header_splitcmd(0, "split")
	  end;
	  description = "Open source/header in a new split";
	};
  }
};

vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

-- ccls

-- nvim_lsp.ccls.setup{
--     cmd = { "/Users/dann/4ms/ccls/Release/ccls" },
--     filetypes = { "c", "cpp", "objc", "objcpp" },
--     root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
-- 	init_options = {
-- 		highlight = {lsRanges = true}
-- 	},
-- 	on_attach = on_attach_vim
-- }

-- lua

nvim_lsp.sumneko_lua.setup {
  capabilities = lsp_status.capabilities,
}

nvim_lsp.rust_analyzer.setup {
	on_attach = on_attach_vim,
	cmd = {"/usr/local/bin/rust-analyzer"},
	filetypes = {"rust"},
	root_dir = nvim_lsp.util.root_pattern("Cargo.toml"),
  capabilities = lsp_status.capabilities,
}

