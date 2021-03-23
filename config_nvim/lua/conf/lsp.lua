if (vim == nil) then vim = {}; end
local nvim_lspconfig = require'lspconfig'
local compe = require'compe'
local RishabhRD_codeAction = require'lsputil.codeAction'
local RishabhRD_locations = require'lsputil.locations'
local RishabhRD_symbols = require'lsputil.symbols'

local conf_lsp = {}
require('plenary.reload').reload_module("lsp_telescope")
conf_lsp.pretty_telescope = require'lsp_telescope'

local useclangd = true
local useccls = false


--
-- Completion
--

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

local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then return true
    else return false
    end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then return t "<C-n>"
  elseif check_back_space() then return t "<Tab>"
  else return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then return t "<C-p>"
  else return t "<S-Tab>"
  end
end
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})

--
-- Formatting
--
FormatSetState = function(value)
    vim.g[string.format("format_disabled_%s", vim.bo.filetype)] = value
end

conf_lsp.lsp_format = function()
	if not vim.g[string.format("format_disabled_%s", vim.bo.filetype)] then
		vim.lsp.buf.formatting_sync(nil, 300)
		-- Can pass options to the formatter:
        -- vim.lsp.buf.formatting(vim.g[string.format("format_options_%s", vim.bo.filetype)] or {})
	end
end

--
-- Diagnostics
--

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
conf_lsp.virtual_text = virtual_text


--
-- LSP Buffer key maps
--

local on_attach_vim = function(client, bufnr)
	print("LSP started: "..client.name);

	local keymap_opts = { noremap=true, silent=true }

	--Symbol info (hover/signature)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', 			'<cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)

	--Refs/Defs
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',			'<cmd>lua require\'conf.lsp\'.pretty_telescope.pretty_refs()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr',	'<cmd>lua vim.lsp.buf.references()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', 			'<cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', 	 		'<cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts)

	-- if client.resolved_capabilities.type_definition then
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', 			'<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts) --not supported by clangd, but works in ccls
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gI', 			'<cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts) --not supported by clangd...
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gn', 			'<cmd>lua vim.lsp.buf.incoming_calls()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gN', 			'<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', keymap_opts)

	--Symbols
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gw',	'<cmd>lua require\'telescope.builtin\'.lsp_workspace_symbols()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gw',			'<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g0', 			'<cmd>lua vim.lsp.buf.document_symbol()<CR>', keymap_opts)

	--Code Action
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', 	'<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)

	--Rename symbol
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', 	'<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)

	--Switch header (replaced with Alternate File)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-h>',			'<cmd>ClangdSwitchSourceHeader<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>h', 	'<cmd>ClangdSwitchSourceHeaderVSplit<CR>', keymap_opts)

	--Diagnostics
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', 	'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f[', 	'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f]', 	'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fp', 	'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', keymap_opts)

	-- Temporarily disable diagnostics (virt text, signs, etc)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fC', '<cmd>lua vim.lsp.diagnostic.clear(0)<CR>', keymap_opts)
	-- Toggle virtual text diagnostics
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>fc', '<cmd>lua require\'conf.lsp\'.virtual_text.toggle()<CR>', keymap_opts)

	--Completion keys
	vim.o.completeopt = "menuone,noselect"

	--Highlight current word
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
        vim.cmd [[autocmd BufWritePre <buffer> lua require'conf.lsp'.lsp_format() ]]
        vim.cmd [[augroup END]]
		vim.cmd [[command! FormatDisable lua FormatSetState(true)]]
		vim.cmd [[command! FormatEnable lua FormatSetState(false)]]
    end

	-- Todo: get this working (re-attach server/client)
	-- buf_set_keymap(bufnr, 'n', '<leader>F', '<cmd>lua require(\'lspconfig\')["clangd"].manager.try_add()<CR>', opts)

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
-- General key maps
--

--Force stop
vim.api.nvim_set_keymap('n', '<leader>lss','<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>', {noremap=true})
--Show debug info
vim.api.nvim_set_keymap('n', '<leader>lsI','<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>', {noremap=true})
-- nnoremap <leader>lsI :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
--Show log
vim.api.nvim_set_keymap('n', '<leader>lsL','<cmd>lua vim.api.nvim_command("e "..vim.lsp.get_log_path())<CR>', {noremap=true})
-- nnoremap <leader>lsL :lua vim.api.nvim_command("e "..vim.lsp.get_log_path())<CR>
--Show completion characters
vim.api.nvim_set_keymap('n', '<leader>lsC','<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))<CR>', {noremap=true})
-- nnoremap <leader>lsC :lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))
--Show current symbol type (useful for completion chain list)
vim.api.nvim_set_keymap('n', '<leader>lsc','<cmd>echo synIDattr(synID(line(\'.\'), col(\'.\'), 1), "name")<CR>', {noremap=true})
-- nnoremap <leader>lsc :echo synIDattr(synID(line('.'), col('.'), 1), "name")<CR>


--
-- scratch pad
--
function _G.hover(_name)
  local name = _name or 'clangd'
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


return conf_lsp
