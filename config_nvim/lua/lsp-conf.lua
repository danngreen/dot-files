if (vim == nil) then
	vim = {}
end
local nvim_lspconfig = require "lspconfig"

local conf_lsp = {}
-- require('plenary.reload').reload_module("lsp_telescope")
conf_lsp.pretty_telescope = require "lsp_telescope"

local useclangd = true
local useccls = false


-- Completion

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Formatting

-- FormatSetState = function(value)
-- 	vim.g[string.format("format_disabled_%s", vim.bo.filetype)] = value
-- end

-- conf_lsp.lsp_format = function()
-- 	if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
-- 		vim.lsp.buf.formatting_sync(nil, 300)
-- 	-- Can pass options to the formatter:
-- 	-- vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
-- 	end
-- end

-- Diagnostics

local virt_text = {}
virt_text.show = true
virt_text.toggle = function()
	virt_text.show = not virt_text.show
	vim.diagnostic.config({virtual_text = virt_text.show})
end
conf_lsp.virt_text = virt_text

-- LSP Buffer key maps

local on_attach_vim = function(client, bufnr)
	print("LSP started: " .. client.name)

	-- local inoremap_cmd = function(k, c)
	-- 	vim.api.nvim_buf_set_keymap(bufnr, "i", k, "<cmd>" .. c .. "<CR>", {noremap = true, silent = true})
	-- end
	local nnoremap_cmd = function(k, c)
		vim.api.nvim_buf_set_keymap(bufnr, "n", k, "<cmd>" .. c .. "<CR>", {noremap = true, silent = true})
	end

	--Symbol info (hover/signature)
	nnoremap_cmd("K", "lua vim.lsp.buf.hover()")
	nnoremap_cmd("<C-k>", "lua vim.lsp.buf.signature_help()")
	--inoremap_cmd("<C-k>", "lua vim.lsp.buf.signature_help()")

	require "lsp_signature".on_attach(
		{
			bind = true,
			fix_pos = true,
			always_trigger = false,
			floating_window = true,
			floating_window_above_cur_line = true,
			handler_opts = {border = "rounded"},
			toggle_key = '<C-k>', --in insert mode
			hint_enable = false
		},
		bufnr
	)

	--Refs/Defs
	nnoremap_cmd("gd", "lua vim.lsp.buf.definition()")
	nnoremap_cmd("gr", "lua require'lsp-conf'.pretty_telescope.pretty_refs()")
	nnoremap_cmd("gD", "lua vim.lsp.buf.declaration()")

	-- if client.resolved_capabilities.type_definition then
	nnoremap_cmd("gi", "lua vim.lsp.buf.type_definition()")
	nnoremap_cmd("gI", "lua vim.lsp.buf.implementation()")
	nnoremap_cmd("gn", "lua vim.lsp.buf.incoming_calls()")
	nnoremap_cmd("gN", "lua vim.lsp.buf.outgoing_calls()")

	--Symbols
	nnoremap_cmd("gw", "Telescope lsp_dynamic_workspace_symbols")
	nnoremap_cmd("g0", "lua vim.lsp.buf.document_symbol()")

	nnoremap_cmd("<leader>ff", "lua require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_cursor())")
	-- nnoremap_cmd('<leader>ff', 	'lua vim.lsp.buf.code_action()') --Doesn't work? See comment in handlers below

	nnoremap_cmd("<leader>rn", "lua Rename.rename()")

	--Switch header (replaced with Alternate File)
	nnoremap_cmd("<M-h>", "ClangdSwitchSourceHeader")
	nnoremap_cmd("<leader>h", "ClangdSwitchSourceHeaderVSplit")

	--Diagnostics
	nnoremap_cmd("<leader>e", 'lua vim.diagnostic.open_float({scope="line"})')
	nnoremap_cmd("<leader>E", 'lua vim.diagnostic.open_float({scope="buffer"})')
	nnoremap_cmd("<leader>f]", "lua vim.diagnostic.goto_next()")
	nnoremap_cmd("<leader>f[", "lua vim.diagnostic.goto_prev()")
	nnoremap_cmd("<leader>fp", "lua vim.diagnostic.setloclist()")
	nnoremap_cmd("<leader>fP", "lua vim.diagnostic.setqflist()")
	nnoremap_cmd("<leader>fC", "lua vim.diagnostic.disable(0)")
	nnoremap_cmd("<leader>fc", "lua require'lsp-conf'.virt_text.toggle()")

	--Completion keys
	vim.o.completeopt = "menuone,noselect"

	--Highlight current word
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
			augroup lsp_document_highlight
				autocmd!
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]],
			false
		)
	end

	--Formatting
	if client.resolved_capabilities.document_formatting then
		vim.cmd [[augroup Format]]
		vim.cmd [[autocmd! * <buffer>]]
		vim.cmd [[autocmd BufWritePre <buffer> lua require'lsp-conf'.lsp_format() ]]
		vim.cmd [[augroup END]]
		-- vim.cmd [[command! FormatDisable lua FormatSetState(true)]]
		-- vim.cmd [[command! FormatEnable lua FormatSetState(false)]]
	end
end

conf_lsp.on_attach_vim = on_attach_vim

-- Handlers

-- Why doesn't setting the codeAction handler not work anymore? Even if telescope opts are empty, it has no effect
-- vim.lsp.handlers['textDocument/codeAction'] = function(opts)
--opts = opts or {}
--opts.layout_config = {height = 7, width=0.3}
-- require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_cursor(opts))
--end

vim.lsp.handlers["workspace/symbol"] = require "telescope.builtin".lsp_dynamic_workspace_symbols
vim.lsp.handlers["textDocument/documentSymbol"] = require "telescope.builtin".lsp_document_symbols

-- From https://www.reddit.com/r/neovim/comments/nsfv7h/rename_in_floating_window_with_neovim_lsp/
local function dorename(win)
	local new_name = vim.trim(vim.fn.getline("."))
	vim.api.nvim_win_close(win, true)
	vim.lsp.buf.rename(new_name)
end

local function rename()
	local opts = {
		relative = "cursor",
		row = 1,
		col = 0,
		width = 30,
		height = 1,
		style = "minimal",
		border = "single"
	}
	local cword = vim.fn.expand("<cword>")
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, opts)
	local fmt = "<cmd>lua Rename.dorename(%d)<CR>"
	local cancel = "<cmd>lua vim.api.nvim_win_close(%d, true)<CR>"

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cword})
	vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", string.format(fmt, win), {silent = true})
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", string.format(fmt, win), {silent = true})
	vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", string.format(cancel, win), {silent = true})
end
_G.Rename = {
	rename = rename,
	dorename = dorename
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "single"})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "single"})

-- Clangd

if (useclangd) then
	local function switch_source_header_splitcmd(bufnr, splitcmd)
		bufnr = require'lspconfig'.util.validate_bufnr(bufnr)
		local clangd_client = require'lspconfig'.util.get_active_client_by_name(bufnr, 'clangd')
		local params = {uri = vim.uri_from_bufnr(bufnr)}
		if clangd_client then
			clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
				if err then
					error(tostring(err))
				end
				if not result then
					print("Corresponding file can’t be determined")
					return
				end
				vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
			end, bufnr)
		else
			print 'textDocument/switchSourceHeader is not supported by the clangd server active on the current buffer'
		end
	end

	nvim_lspconfig.clangd.setup {
		cmd = {
			"clangd",
			"--background-index",
			--"--log=verbose",
			"-j=32",
			"--fallback-style=LLVM",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--header-insertion-decorators",
			"--completion-style=bundled",
			"--query-driver=/usr/local/bin/arm-none-eabi-g*",
			"--query-driver=/Users/**/4ms/stm32/gcc-arm-none-eabi-*/bin/arm-none-eabi-*",
			"--query-driver=/usr/bin/g*",
			"--query-driver=/usr/local/opt/llvm/bin/clang*",
			"--pch-storage=memory",
			"--enable-config"
		},
		filetypes = {"c", "cpp"},
		root_dir = nvim_lspconfig.util.root_pattern(".clangd", "compile_commands.json"),
		on_attach = on_attach_vim,
		capabilities = capabilities,

		on_init = function(client)
			client.config.flags.allow_incremental_sync = true
			client.config.flags.debounce_text_changes = 100
		end,
		init_options = {clangdFileStatus = false},
		commands = {
			ClangdSwitchSourceHeader = {
				function()
					switch_source_header_splitcmd(0, "edit")
				end,
				description = "Open source/header in a new vsplit"
			},
			ClangdSwitchSourceHeaderVSplit = {
				function()
					switch_source_header_splitcmd(0, "vsplit")
				end,
				description = "Open source/header in a new vsplit"
			},
			ClangdSwitchSourceHeaderSplit = {
				function()
					switch_source_header_splitcmd(0, "split")
				end,
				description = "Open source/header in a new split"
			}
		}
	}
end --Clangd

-- ccls

if (useccls) then
	nvim_lspconfig.ccls.setup(
		{
			cmd = {"/usr/local/bin/ccls"},
			filetypes = {"c", "cpp", "objc", "objcpp"},
			root_dir = nvim_lspconfig.util.root_pattern(".ccls", "compile_commands.json"),
			init_options = {
				highlight = {lsRanges = true},
				cache = {retainInMemory = 1},
				diagnostics = {
					onOpen = 0,
					onChange = 0,
					onSave = 100
				},
				index = {threads = 16}
			},
			capabilities = {textDocument = {completion = {completionItem = {snippetSupport = false}}}},
			on_attach = on_attach_vim
		}
	)
end

-- Lua

nvim_lspconfig.sumneko_lua.setup {
	require "conf.lua-lsp",
	cmd = {
		"/Users/dann/bin/lua-language-server/bin/macOS/lua-language-server",
		"-E",
		"/Users/dann/bin/lua-language-server/main.lua"
	},
	on_attach = on_attach_vim
}

-- rust

nvim_lspconfig.rust_analyzer.setup {
	on_attach = on_attach_vim,
	cmd = {"rust-analyzer"},
	filetypes = {"rust"},
	-- root_dir = nvim_lspconfig.util.root_pattern("Cargo.toml"),
	root_dir = function(fname)
		local cargo_metadata = vim.fn.system("cargo metadata --no-deps --format-version 1")
		local cargo_root = nil
		if vim.v.shell_error == 0 then
			cargo_root = vim.fn.json_decode(cargo_metadata)["workspace_root"]
		end
		return cargo_root or nvim_lspconfig.util.find_git_ancestor(fname) or
			nvim_lspconfig.util.root_pattern("rust-project.json")(fname) or
			nvim_lspconfig.util.root_pattern("Cargo.toml")(fname)
	end,
	settings = {
		["rust-analyzer"] = {}
	},
	capabilities = (function()
		local rust_capabilities = capabilities --vim.lsp.protocol.make_client_capabilities()
		rust_capabilities.textDocument.completion.completionItem.snippetSupport = true
		rust_capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits"
			}
		}
		return capabilities
	end)()
}

-- tsserver/javascript

nvim_lspconfig.tsserver.setup {
	filetypes = {"javascript"},
	root_dir = nvim_lspconfig.util.root_pattern(".git"),
	on_attach = on_attach_vim
}

-- cmake
nvim_lspconfig.cmake.setup {
	on_attach = on_attach_vim
}

-- python
nvim_lspconfig.pyright.setup{
	on_attach = on_attach_vim
}

-- html

nvim_lspconfig.html.setup {
	on_attach = on_attach_vim,
	cmd = {"html-languageserver", "--stdio"},
	filetypes = {"html"},
	init_options = {
		configurationSection = {"html", "css", "javascript"},
		embeddedLanguages = {
			css = true,
			javascript = true
		}
	},
	root_dir = nvim_lspconfig.util.root_pattern(".git"),
	settings = {}
}

--
--

-- General key maps

--Force stop
vim.api.nvim_set_keymap(
	"n",
	"<leader>lss",
	"<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>",
	{noremap = true}
)
--Show debug info
vim.api.nvim_set_keymap(
	"n",
	"<leader>lsI",
	"<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>",
	{noremap = true}
)
--Show log
vim.api.nvim_set_keymap(
	"n",
	"<leader>lsL",
	'<cmd>lua vim.api.nvim_command("e "..vim.lsp.get_log_path())<CR>',
	{noremap = true}
)
--Show completion characters
vim.api.nvim_set_keymap(
	"n",
	"<leader>lsC",
	"<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))<CR>",
	{noremap = true}
)
--Show current symbol type (useful for completion chain list)
vim.api.nvim_set_keymap(
	"n",
	"<leader>lsc",
	'<cmd>echo synIDattr(synID(line(\'.\'), col(\'.\'), 1), "name")<CR>',
	{noremap = true}
)

-- scratch pad

function _G.hover(_name)
	local name = _name or "clangd"
	local clients =
		vim.tbl_filter(
		function(c)
			return c.name == name
		end,
		vim.lsp.get_active_clients()
	)
	local match, client = next(clients)
	assert(match, "No active client found with name=" .. name)
	client.request("textDocument/hover", vim.lsp.util.make_position_params())
end

function _G.footest()
	-- local win = vim.api.nvim_get_current_win() -- save where we are now
	local bufnr = vim.api.nvim_get_current_buf()
	local params = vim.lsp.util.make_position_params() -- create params for "go to definition"
	local method = "textDocument/references"
	-- vim.cmd [[vsplit]] -- new split
	local lsp_response = vim.lsp.buf_request_sync(bufnr, method, params, 1000) -- call the LSP(s)
	local result = {}
	for _, client in pairs(lsp_response) do -- loop over all LSPs
		for _, r in pairs(client.result) do -- loop over all results per LSP
			table.insert(result, r) -- put them in a table
		end
	end
	print(vim.inspect(result))
	-- vim.lsp.handlers[method](nil, method, result) -- call the handler
	-- vim.api.nvim_set_current_win(win) -- return to the original window
end

return conf_lsp
