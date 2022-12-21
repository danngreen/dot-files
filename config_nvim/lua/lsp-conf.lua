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
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Diagnostics

local virt_text = {}
virt_text.show = true
virt_text.toggle = function()
	virt_text.show = not virt_text.show
	vim.diagnostic.config({virtual_text = virt_text.show})
end
conf_lsp.virt_text = virt_text

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- LSP Buffer key maps

local on_attach_vim = function(client, bufnr)
	print("LSP started: " .. client.name)

	local bufopt = {buffer=bufnr}
	vim.lsp.set_log_level("ERROR")

	--Symbol info (hover/signature)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopt)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopt)
	vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, bufopt)
	vim.keymap.set("i", "<M-k>", vim.lsp.buf.hover, bufopt)

	--Symbol list
	vim.keymap.set("n", "gw", "<cmd>Telescope lsp_dynamic_workspace_symbols", bufopt)
	vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, bufopt)

	--Refs/Defs
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopt)
	vim.keymap.set("n", "gr", require'lsp-conf'.pretty_telescope.pretty_refs, bufopt)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopt)
	vim.keymap.set("n", "gi", vim.lsp.buf.type_definition, bufopt)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, bufopt)
	vim.keymap.set("n", "gn", vim.lsp.buf.incoming_calls, bufopt)
	vim.keymap.set("n", "gN", vim.lsp.buf.outgoing_calls, bufopt)


	--Workspace
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopt)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopt)
	vim.keymap.set('n', '<leader>wl',
		function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		bufopt)

	--Actions
	vim.keymap.set("n", "<leader>ff", vim.lsp.buf.code_action, bufopt)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopt)
	vim.keymap.set("n", "<M-h>", "<cmd>ClangdSwitchSourceHeader<CR>", bufopt)
	vim.keymap.set("n", "<leader>h", "<cmd>ClangdSwitchSourceHeader<CR>", bufopt)
	vim.keymap.set("n", "<leader><leader>h", "<cmd>ClangdSwitchSourceHeaderVSplit<CR>", bufopt)

	--Diagnostics
	vim.keymap.set("n", "<leader>e",  function() vim.diagnostic.open_float({scope="line"}) end, bufopt)
	vim.keymap.set("n", "<leader>E",  function() vim.diagnostic.open_float({scope="buffer"}) end, bufopt)
	vim.keymap.set("n", "<leader>fn", vim.diagnostic.goto_next, bufopt)
	vim.keymap.set("n", "<leader>fp", vim.diagnostic.goto_prev, bufopt)
	-- vim.keymap.set("n", "<leader>fp", vim.diagnostic.setloclist, bufopt)
	vim.keymap.set("n", "<leader>fq", vim.diagnostic.setqflist, bufopt)
	vim.keymap.set("n", "<leader>fC", function() vim.diagnostic.disable(0) end, bufopt)
	vim.keymap.set("n", "<leader>fc", require'lsp-conf'.virt_text.toggle, bufopt)

	--Completion keys
	vim.o.completeopt = "menuone,noselect"

	--Highlight current word
	if client.server_capabilities.documentHighlightProvider then --document_highlight then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
				autocmd!
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end

	--Formatting
	require "lsp-format".on_attach(client)
end

conf_lsp.on_attach_vim = on_attach_vim

-- Handlers

vim.lsp.handlers["workspace/symbol"] = require "telescope.builtin".lsp_dynamic_workspace_symbols
vim.lsp.handlers["textDocument/documentSymbol"] = require "telescope.builtin".lsp_document_symbols
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
		autostart=true,
		cmd = {
			"/Users/dann/bin/clang+llvm-15.0.0-rc2-x86_64-apple-darwin/bin/clangd",
			"--background-index",
			-- "--log=verbose",
			"-j=16",
			"--fallback-style=LLVM",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--header-insertion-decorators",
			"--completion-style=bundled",
			"--query-driver=/usr/local/bin/arm-none-eabi-g*",
			"--query-driver=/Users/**/4ms/stm32/*-arm-none-eabi*/bin/arm-none-eabi-*",
			"--query-driver=/usr/bin/g*",
			"--query-driver=/usr/local/opt/llvm/bin/clang*",
			"--pch-storage=memory",
			"--enable-config"
		},
		filetypes = {"c", "cpp"},
		root_dir = nvim_lspconfig.util.root_pattern(".clangd", "compile_commands.json", "build/compile_commands.json"),
		on_attach = on_attach_vim,
		capabilities = capabilities,

		on_init = function(client)
			client.config.flags.allow_incremental_sync = true
			client.config.flags.debounce_text_changes = 100
		end,
		init_options = {clangdFileStatus = false},
		commands = {
			ClangdSwitchSourceHeader = {
				function() switch_source_header_splitcmd(0, "edit") end,
				description = "Open source/header in a new vsplit"
			},
			ClangdSwitchSourceHeaderVSplit = {
				function() switch_source_header_splitcmd(0, "vsplit") end,
				description = "Open source/header in a new vsplit"
			},
			ClangdSwitchSourceHeaderSplit = {
				function() switch_source_header_splitcmd(0, "split") end,
				description = "Open source/header in a new split"
			}
		}
	}

	--require("clangd_extensions").setup {
    --server = {
        ---- options to pass to nvim-lspconfig
        ---- i.e. the arguments to require("lspconfig").clangd.setup({})
	--	cmd = {
	--		"/Users/design/bin/clangd_snapshot_20220206/bin/clangd",
	--		--"clangd",
	--		"--background-index",
	--		"--log=verbose",
	--		"-j=32",
	--		"--fallback-style=LLVM",
	--		"--clang-tidy",
	--		"--header-insertion=iwyu",
	--		"--header-insertion-decorators",
	--		"--completion-style=bundled",
	--		"--query-driver=/usr/local/bin/arm-none-eabi-g*",
	--		"--query-driver=/Users/**/4ms/stm32/gcc-arm-none-eabi-*/bin/arm-none-eabi-*",
	--		"--query-driver=/usr/bin/g*",
	--		"--query-driver=/usr/local/opt/llvm/bin/clang*",
	--		"--pch-storage=memory",
	--		"--enable-config"
	--	},
	--	filetypes = {"c", "cpp"},
	--	root_dir = nvim_lspconfig.util.root_pattern(".clangd", "compile_commands.json"),
	--	on_attach = on_attach_vim,
	--	capabilities = capabilities,

	--	on_init = function(client)
	--		client.config.flags.allow_incremental_sync = true
	--		client.config.flags.debounce_text_changes = 100
	--	end,
	--	init_options = {clangdFileStatus = false},
	--	commands = {
	--		ClangdSwitchSourceHeader = {
	--			function()
	--				switch_source_header_splitcmd(0, "edit")
	--			end,
	--			description = "Open source/header in a new vsplit"
	--		},
	--		ClangdSwitchSourceHeaderVSplit = {
	--			function()
	--				switch_source_header_splitcmd(0, "vsplit")
	--			end,
	--			description = "Open source/header in a new vsplit"
	--		},
	--		ClangdSwitchSourceHeaderSplit = {
	--			function()
	--				switch_source_header_splitcmd(0, "split")
	--			end,
	--			description = "Open source/header in a new split"
	--		}
	--	}
    --},
    --extensions = {
        --autoSetHints = true,
        ---- Whether to show hover actions inside the hover window
        ---- This overrides the default hover handler
        --hover_with_actions = true,
        --inlay_hints = {
            --only_current_line = true,
            ---- Event which triggers a refresh of the inlay hints.
            ---- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            ---- not that this may cause  higher CPU usage.
            ---- This option is only respected when only_current_line and
            ---- autoSetHints both are true.
            --only_current_line_autocmd = "CursorMoved,CursorHold",
            ---- wheter to show parameter hints with the inlay hints or not
            --show_parameter_hints = true,
            ---- whether to show variable name before type hints with the inlay hints or not
            --show_variable_name = true,
            ---- prefix for parameter hints
            --parameter_hints_prefix = "<- ",
            ---- prefix for all the other hints (type, chaining)
            --other_hints_prefix = "=> ",
            ---- whether to align to the length of the longest line in the file
            --max_len_align = true,
            ---- padding from the left if max_len_align is true
            --max_len_align_padding = 1,
            ---- whether to align to the extreme right or not
            --right_align = false,
            ---- padding from the right if right_align is true
            --right_align_padding = 7,
            ---- The color of the hints
            --highlight = "DiagnosticHint",
        --},
    --}
--}
end --Clangd

-- ccls

if (useccls) then
	require("ccls").setup({
		win_config = {
			-- Sidebar configuration
			sidebar = {
				size = 50,
				position = "topleft",
				split = "vnew",
				width = 50,
				height = 20,
			},
			-- floating window configuration. check :help nvim_open_win for options
			float = {
				style = "minimal",
				relative = "cursor",
				width = 50,
				height = 20,
				row = 0,
				col = 0,
				border = "rounded",
			},
		},
		filetypes = {"c", "cpp"},

		lsp = {
			-- using vim.lsp.start:
			server = {
				name = "ccls",
				cmd = {"/opt/homebrew/bin/ccls"},
				args = {},
				offset_encoding = "utf-8",
				root_dir = vim.fs.dirname(
					vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1]
				),
				on_attach = function()
					vim.keymap.set("n", "gii", "<cmd>CclsMemberHierarchy float<CR>", {buffer=0})
				end
				--capabilites = your_table/func
			},

			--Disalbe features so we don't conflict with clangd:
			disable_capabilities = {
				completionProvider = true,
				documentFormattingProvider = true,
				documentRangeFormattingProvider = true,
				documentHighlightProvider = true,
				documentSymbolProvider = true,
				workspaceSymbolProvider = true,
				renameProvider = true,
				hoverProvider = true,
				codeActionProvider = true,
			},
			disable_diagnostics = true,
			disable_signature = true,
		},
	})

	-- nvim_lspconfig.ccls.setup(
	-- 	{
	-- 		cmd = {"/opt/homebrew/bin/ccls"},
	-- 		filetypes = {"c", "cpp", "objc", "objcpp"},
	-- 		root_dir = nvim_lspconfig.util.root_pattern(".ccls", "compile_commands.json"),
	-- 		init_options = {
	-- 			highlight = {lsRanges = true},
	-- 			cache = {retainInMemory = 1},
	-- 			diagnostics = {
	-- 				onOpen = 0,
	-- 				onChange = 0,
	-- 				onSave = 100
	-- 			},
	-- 			index = {threads = 16}
	-- 		},
	-- 		capabilities = {textDocument = {completion = {completionItem = {snippetSupport = false}}}},
	-- 		on_attach = on_attach_vim
	-- 	}
	-- )
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

-- System Verilog
-- nvim_lspconfig.svls.setup({
-- 	on_attach = on_attach_vim,
-- })




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
