local nvim_lspconfig = require'lspconfig'
local compe = require'compe'
local RishabhRD_codeAction = require'lsputil.codeAction'
local RishabhRD_locations = require'lsputil.locations'
local RishabhRD_symbols = require'lsputil.symbols'

local lsp_conf = {}

require('plenary.reload').reload_module("lsp_telescope")
lsp_conf.pretty_telescope = require'lsp_telescope'

local useclangd = false
local useccls = true

if (vim == nil) then vim = {}; end

compe.setup {
	enabled = true;
	debug = false;
	min_length = 2;
	preselect = 'disable'; -- 'enable' || 'disable' || 'always';
	-- throttle_time = 80; --what is this? Something to do with preventing flickering?
	source_timeout = 500; --what is this?
	incomplete_delay = 400; --what is this?
	allow_prefix_unmatch = true; --when false, only matches with the same first char will be shown

	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = true;

	source = {
		path = true;
		buffer = true;
		calc = true;
		vsnip = false;
		nvim_lsp = true;
		nvim_lua = true;
		tags = false;
		treesitter = false;
	};
}

--
-- Formatting
--
FormatSetState = function(value)
    vim.g[string.format("format_disabled_%s", vim.bo.filetype)] = value
end

lsp_conf.lsp_format = function()
	if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
		vim.lsp.buf.formatting_sync(nil, 500)
		-- Can pass options to the formatter:
        -- vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
	end
end

local virtual_text = {}
virtual_text.show = true
virtual_text.toggle = function()
    virtual_text.show = not virtual_text.show
    vim.lsp.diagnostic.display(
        vim.lsp.diagnostic.get(0, 1),
        0, 1,
        {virtual_text = virtual_text.show}
    )
end
lsp_conf.virtual_text = virtual_text


local buf_set_keymap = vim.api.nvim_buf_set_keymap
local on_attach_vim = function(client, bufnr)
	print("LSP started: "..client.name);

	local opts = { noremap=true, silent=true }
	--Symbol info (hover/signature)
	buf_set_keymap(bufnr, 'n', 'K', 			'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap(bufnr, 'i', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

	--Refs/Defs
	buf_set_keymap(bufnr, 'n', 'gr',			'<cmd>lua require\'lsp_conf\'.pretty_telescope.pretty_refs()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>gr',	'<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'gd', 			'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'gD', 	 		'<cmd>lua vim.lsp.buf.declaration()<CR>', opts)

	-- if client.resolved_capabilities.type_definition then
	buf_set_keymap(bufnr, 'n', 'gi', 			'<cmd>lua vim.lsp.buf.type_definition()<CR>', opts) --not supported by clangd, but works in ccls
	buf_set_keymap(bufnr, 'n', 'gI', 			'<cmd>lua vim.lsp.buf.implementation()<CR>', opts) --not supported by clangd
	buf_set_keymap(bufnr, 'n', 'gn', 			'<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'gN', 			'<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

	--Symbols
	buf_set_keymap(bufnr, 'n', '<leader>gw',	'<cmd>lua require\'telescope.builtin\'.lsp_workspace_symbols()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'gw',			'<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'g0', 			'<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)

	--Code Action
	buf_set_keymap(bufnr, 'n', '<leader>ff', 	'<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

	--Rename symbol
	buf_set_keymap(bufnr, 'n', '<leader>rn', 	'<cmd>lua vim.lsp.buf.rename()<CR>', opts)

	--Switch header (replaced with Alternate File)
	buf_set_keymap(bufnr, 'n', '<M-h>',			'<cmd>ClangdSwitchSourceHeader<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>h', 	'<cmd>ClangdSwitchSourceHeaderVSplit<CR>', opts)

	-- buf_set_keymap(bufnr, 'n', 'gh', 			'<cmd>lua require\'lspsaga.provider\'.lsp_finder()<CR>', opts)
	-- buf_set_keymap(bufnr, 'n', 'gp', 			'<cmd>lua require\'lspsaga.provider\'.preview_definition()<CR>', opts)

	--Diagnostics
	buf_set_keymap(bufnr, 'n', '<leader>e', 	'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>f[', 	'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>f]', 	'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>fp', 	'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Temporarily disable diagnostics (virt text, signs, etc)
	buf_set_keymap(bufnr, 'n', '<leader>fC', '<cmd>lua vim.lsp.diagnostic.clear(0)<CR>', opts)
	-- Toggle virtual text diagnostics
	buf_set_keymap(bufnr, 'n', '<leader>fc', '<cmd>lua require\'lsp_conf\'.virtual_text.toggle()<CR>', opts)

	-- buf_set_keymap(bufnr, 'n', '<leader>F', '<cmd>lua require(\'lspconfig\')["clangd"].manager.try_add()<CR>', opts)


	--Completion
	vim.o.completeopt = "menuone,noselect"

	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
				autocmd!
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end

	--Formatting
	if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp_conf'.lsp_format() ]]
        vim.cmd [[augroup END]]
		vim.cmd [[command! FormatDisable lua FormatSetState(true)]]
		vim.cmd [[command! FormatEnable lua FormatSetState(false)]]
    end

end

--
-- Handlers
--

vim.lsp.handlers['textDocument/codeAction'] = RishabhRD_codeAction.code_action_handler
vim.lsp.handlers['textDocument/references'] = RishabhRD_locations.references_handler
-- vim.lsp.handlers['textDocument/definition'] = RishabhRD_locations.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] = RishabhRD_locations.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] = RishabhRD_locations.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] = RishabhRD_locations.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = RishabhRD_symbols.document_handler
vim.lsp.handlers['workspace/symbol'] = RishabhRD_symbols.workspace_handler


local border_chars = {
	TOP_LEFT = '┌',
	TOP_RIGHT = '┐',
	MID_HORIZONTAL = '─',
	MID_VERTICAL = '│',
	BOTTOM_LEFT = '└',
	BOTTOM_RIGHT = '┘',
}
vim.g.lsp_utils_location_opts = {
	height = 24,
	mode = 'editor',
	preview = {
		title = 'Location Preview',
		border = true,
		border_chars = border_chars
	},
	keymaps = {
		n = {
			['<C-n>'] = 'j',
			['<C-p>'] = 'k',
		}
	}
}
vim.g.lsp_utils_symbols_opts = {
	height = 24,
	mode = 'editor',
	preview = {
		title = 'Symbols Preview',
		border = true,
		border_chars = border_chars
	},
	prompt = {},
}

--
-- Clangd
--

if (useclangd) then

local function switch_source_header_splitcmd(bufnr, splitcmd)
	bufnr = nvim_lspconfig.util.validate_bufnr(bufnr)
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
		if err then error(tostring(err)) end
		if not result then print ("Corresponding file can’t be determined") return end
		-- print("Switching to "..vim.uri_from_fname(result))
		vim.api.nvim_command(splitcmd..' '..vim.uri_to_fname(result))
	end)
end
-- nvim_lspconfig.clangd.switch_source_header_splitcmd = switch_source_header_splitcmd

nvim_lspconfig.clangd.setup {
	cmd = {
		"/Users/dann/bin/clangd_12.0.0-rc2/bin/clangd",
		"--background-index",
		"--log=verbose",
		"-j=32",
		"--cross-file-rename",
		"--fallback-style=LLVM",
		-- "--clang-tidy",
		-- "--suggest-missing-includes",
		-- "--all-scopes-completion",
		"--completion-style=bundled",
		"--query-driver=/Users/dann/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-*",
		"--query-driver=/usr/local/Cellar/arm-none-eabi-gcc/8-2018-q4-major/*/bin/*/arm-none-eabi-g*",
		"--query-driver=/usr/bin/g*",
		"--query-driver=/usr/local/bin/arm-none-eabi-g*",
		"--pch-storage=memory",
		"--enable-config"
	},
	filetypes = {"c", "cpp", "objc", "objcpp"},
	root_dir = nvim_lspconfig.util.root_pattern(".clangd", "compile_commands.json" ),
	on_attach = on_attach_vim,
	capabilities = { textDocument = { completion = { completionItem = { snippetSupport = false } } } },

	--Are both of these actually needed?
	on_init = function(client)
        client.config.flags = {}
        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end
    end;
	flags = {allow_incremental_sync = true},

	init_options = { clangdFileStatus = false, },
	commands = {
		ClangdSwitchSourceHeader = {
			function() switch_source_header_splitcmd(0, "edit") end;
			description = "Open source/header in a new vsplit";
		},
		ClangdSwitchSourceHeaderVSplit = {
			function() switch_source_header_splitcmd(0, "vsplit") end;
			description = "Open source/header in a new vsplit";
		},
		ClangdSwitchSourceHeaderSplit = {
			function() switch_source_header_splitcmd(0, "split") end;
			description = "Open source/header in a new split";
		};
	}
};
end --Clangd

--
-- ccls
--
--
if (useccls) then

nvim_lspconfig.ccls.setup( {
	cmd = { "/usr/local/bin/ccls" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = nvim_lspconfig.util.root_pattern(".ccls", "compile_commands.json"),
	init_options = {
		highlight = {lsRanges = true},
		cache = {retainInMemory = 1},
		diagnostics = {
			onOpen = 0,
			onChange = 0,
			onSave = 100
		},
		index = { threads = 16 }
	},
	capabilities = { textDocument = { completion = { completionItem = { snippetSupport = false } } } },
	on_attach = on_attach_vim,
})

end


-- lua

nvim_lspconfig.sumneko_lua.setup {
	cmd = {"/Users/dann/bin/lua-language-server/bin/macOS/lua-language-server", "-E", "/Users/dann/bin/lua-language-server/main.lua"},
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = vim.split(package.path, ';'), },
			completion = { keywordSnippet = "Disable", },
			diagnostics = { enable = true, globals = {
				"vim", "describe", "it", "before_each", "after_each" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				}
			},
		}
	},
	on_attach = on_attach_vim
}

-- rust

nvim_lspconfig.rust_analyzer.setup {
	on_attach = on_attach_vim,
	cmd = {"/usr/local/bin/rust-analyzer"},
	filetypes = {"rust"},
	root_dir = nvim_lspconfig.util.root_pattern("Cargo.toml"),
	settings = {
		["rust-analyzer"] = {
			cargo = {
				target = "thumbv7m-none-eabi"
			},
			checkOnSave = {
				all_targets = false
			}
		}
	}
}

-- tsserver/javascript

nvim_lspconfig.tsserver.setup {
	filetypes = {"javascript"},
	root_dir = nvim_lspconfig.util.root_pattern(".git"),
	on_attach = on_attach_vim,
}

-- cmake

nvim_lspconfig.cmake.setup {}

--
-- scratch pad
--
function _G.hover(name)
  local name = name or 'clangd'
  local clients = vim.tbl_filter(function(c) return c.name == name end,  vim.lsp.get_active_clients())
  local match, client = next(clients)
  assert(match, 'No active client found with name=' .. name)
  client.request('textDocument/hover', vim.lsp.util.make_position_params())
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


return lsp_conf
