local nvim_lsp = require'nvim_lsp'
local buf_set_keymap = vim.api.nvim_buf_set_keymap

local on_attach_vim = function(client, bufnr)
  print("LSP started");
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap(bufnr, 'n', 'K', 		'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<C-k>', 	'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',rn', 	'<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',e', 		'<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',gr',		'<cmd>lua require\'telescope.builtin\'.lsp_references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr',  	'<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gd', 		'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap(bufnr, 'n', 'gD', 		'<cmd>lua vim.lsp.buf.type_definition()<CR>', opts) --not supported by clangd
  buf_set_keymap(bufnr, 'n', 'gD', 	'<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap(bufnr, 'n', ',gW',		'<cmd>lua require\'telescope.builtin\'.lsp_workspace_symbols()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gW',  	'<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'g0', 		'<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  -- buf_set_keymap(bufnr, 'n', 'gI', 		'<cmd>lua vim.lsp.buf.implementation()<CR>', opts) --not supported by clangd
  buf_set_keymap(bufnr, 'n', ',ff',		'<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
end

-- nvim_lsp.ccls.setup{
--     cmd = { "/Users/dann/4ms/ccls/Release/ccls" },
--     filetypes = { "c", "cpp", "objc", "objcpp" },
--     root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
-- 	init_options = {
-- 		highlight = {lsRanges = true}
-- 	},
-- 	on_attach = on_attach_vim
-- }

-- local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then error(tostring(err)) end
    if not result then print ("Corresponding file can’t be determined") return end
    vim.api.nvim_command('edit '..vim.uri_to_fname(result))
  end)
end

local root_pattern = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")

nvim_lsp.clangd.setup {
  cmd = {"/usr/local/opt/llvm/bin/clangd", "--background-index", "--log=verbose", "--cross-file-rename", "--suggest-missing-includes", "--all-scopes-completion"},
  filetypes = {"c", "cpp", "objc", "objcpp"},
  root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  on_attach = on_attach_vim
}
  -- commands = {
	-- ClangdSwitchSourceHeader = {
	  -- function()
		-- switch_source_header(0)
	  -- end;
	  -- description = "Switch between source/header";
	-- };
  -- };

-- nvim_lsp.clangd.switch_source_header = switch_source_header
  -- root_dir = function(fname)
  --   local filename = util.path.is_absolute(fname) and fname
  --     or util.path.join(vim.loop.cwd(), fname)
  --   return root_pattern(filename) or util.path.dirname(filename)
  -- end;

vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
-- vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler



--Show all diagnostics in quickfix?
-- https://github.com/neovim/nvim-lspconfig/issues/69
 -- do
 --   local method = "textDocument/publishDiagnostics"
 --   local default_callback = vim.lsp.callbacks[method]
 --   vim.lsp.callbacks[method] = function(err, method, result, client_id)
 --     default_callback(err, method, result, client_id)
 --     if result and result.diagnostics then
 --       for _, v in ipairs(result.diagnostics) do
 --         v.bufnr = client_id
 --         v.lnum = v.range.start.line + 1
 --         v.col = v.range.start.character + 1
 --         v.text = v.message
 --       end
 --       vim.lsp.util.set_qflist(result.diagnostics)
 --     end
 --   end
 -- end
