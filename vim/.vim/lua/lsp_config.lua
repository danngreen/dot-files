local useclangd = true
-- local useclangd = false
local useccls = not useclangd;

if (vim == nil) then vim = {}; end

local nvim_lsp = require'lspconfig'
local util = require'lspconfig/util'
local telescope = require'telescope.builtin'

-- local saga = require'lspsaga'

-- saga.init_lsp_saga{
-- 	border_style = 2,
-- 	max_hover_width = 100,
-- 	-- use_saga_diagnostic_handler = true
-- 	-- use_saga_diagnostic_sign = true
-- 	error_sign = '☓',
-- 	warn_sign = '▻',
-- 	hint_sign = '➝',
-- 	infor_sign = '◦',
-- 	code_action_icon = ' ',
-- 	finder_definition_icon = '== ',
-- 	finder_reference_icon = '& ',
-- 	definition_preview_icon = '(==) '
-- 	-- reanme_row = 1
-- }

require'compe'.setup {
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
		treesitter = true;
	};
}

local buf_set_keymap = vim.api.nvim_buf_set_keymap
local on_attach_vim = function(client, bufnr)
	print("LSP started");

	local opts = { noremap=true, silent=true }
	--Symbol info (hover/signature)
	buf_set_keymap(bufnr, 'n', 'K', 			'<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap(bufnr, 'i', '<C-k>', 		'<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

	--Refs/Defs
	buf_set_keymap(bufnr, 'n', 'gr',			'<cmd>lua require\'telescope.builtin\'.lsp_references{}<CR>', opts)
	-- buf_set_keymap(bufnr, 'n', 'gr',			'<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'gd', 			'<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap(bufnr, 'n', 'gD', 	 		'<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		-- if client.resolved_capabilities.type_definition then --?
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
	-- buf_set_keymap(bufnr, 'n', '<leader>ff', 	'<cmd>lua require\'lspsaga.codeaction\'.code_action()<CR>', opts)

	--Rename symbol
	buf_set_keymap(bufnr, 'n', '<leader>rn', 	'<cmd>lua vim.lsp.buf.rename()<CR>', opts)

	--Switch header (replaced with Alternate File)
	--buf_set_keymap(bufnr, 'n', '<M-h>',		'<cmd>ClangdSwitchSourceHeader<CR>', opts)
	--buf_set_keymap(bufnr, 'n', '<leader>h', 	'<cmd>ClangdSwitchSourceHeaderVSplit<CR>', opts)

	-- buf_set_keymap(bufnr, 'n', 'gh', 			'<cmd>lua require\'lspsaga.provider\'.lsp_finder()<CR>', opts)
	-- buf_set_keymap(bufnr, 'n', 'gp', 			'<cmd>lua require\'lspsaga.provider\'.preview_definition()<CR>', opts)

	--Diagnostics
	buf_set_keymap(bufnr, 'n', '<leader>e', 	'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>f[', 	'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>f]', 	'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>fp', 	'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Temporarily disable diagnostics
	buf_set_keymap(bufnr, 'n', '<leader>fC', '<cmd>lua vim.lsp.diagnostic.clear(0)<CR>', opts)
	buf_set_keymap(bufnr, 'n', '<leader>fc', '<cmd>let b:show_diags = exists("b:show_diags") ? 1-b:show_diags : 0<CR>', opts)

	-- buf_set_keymap(bufnr, 'n', '<leader>F', '<cmd>lua require(\'lspconfig\')["clangd"].manager.try_add()<CR>', opts)


	--Completion
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	vim.o.completeopt = "menuone,noselect"

	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			hi LspReferenceText guibg=#442244 
			augroup lsp_document_highlight
				autocmd!
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end
end

local function should_show_diagnostics()
	return vim.b.show_diags ~= 0
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		update_in_insert = true,
		signs = function(_,_) if should_show_diagnostics() then return true else return false end end,
		underline = function(_,_) if should_show_diagnostics() then return true else return false end end,
		virtual_text =
			function (_, _)
				if (should_show_diagnostics()) then return {spacing = 4}
				else return false
			end
		end,
	}
)

-- Clangd
if (useclangd) then

-- local function switch_source_header_splitcmd(bufnr, splitcmd)
-- 	bufnr = util.validate_bufnr(bufnr)
-- 	local params = { uri = vim.uri_from_bufnr(bufnr) }
-- 	vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
-- 		if err then error(tostring(err)) end
-- 		if not result then print ("Corresponding file can’t be determined") return end
-- 		vim.api.nvim_command(splitcmd..' '..vim.uri_to_fname(result))
-- 	end)
-- end

-- nvim_lsp.clangd.switch_source_header_splitcmd = switch_source_header_splitcmd

nvim_lsp.clangd.setup {
	cmd = {
		"/Users/dann/bin/clangd_11.0.0-rc1/bin/clangd",
		-- "/Users/dann/bin/clangd_snapshot_20210113/bin/clangd",
		"--background-index",
		"--log=verbose",
		"-j=32",
		-- "--clang-tidy",
		"--cross-file-rename",
		-- "--suggest-missing-includes",
		-- "--all-scopes-completion",
		"--completion-style=bundled",
		"--query-driver=/Users/dann/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-*",
		"--query-driver=/usr/local/Cellar/arm-none-eabi-gcc/8-2018-q4-major/bin/arm-none-eabi-g*",
		"--query-driver=/usr/bin/g*",
		"--pch-storage=memory",
		"--enable-config"
	},
	filetypes = {"c", "cpp", "objc", "objcpp"},
	root_dir = nvim_lsp.util.root_pattern(".clangd", "compile_commands.json" ),
	on_attach = on_attach_vim,
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = false
				}
			}
		}
	},
	flags = {allow_incremental_sync = true},
	init_options = {
		clangdFileStatus = false
	},
	-- commands = {
	-- 	ClangdSwitchSourceHeader = {
	-- 		function() switch_source_header_splitcmd(0, "edit") end;
	-- 		description = "Open source/header in a new vsplit";
	-- 	},
	-- 	ClangdSwitchSourceHeaderVSplit = {
	-- 		function() switch_source_header_splitcmd(0, "vsplit") end;
	-- 		description = "Open source/header in a new vsplit";
	-- 	},
	-- 	ClangdSwitchSourceHeaderSplit = {
	-- 		function() switch_source_header_splitcmd(0, "split") end;
	-- 		description = "Open source/header in a new split";
	-- 	};
	-- }
};

end --Clangd

-- ccls
if (useccls) then

nvim_lsp.ccls.setup( {
	cmd = { "/Users/design/4ms/ccls/Release/ccls" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = nvim_lsp.util.root_pattern(".ccls", "compile_commands.json"),
	init_options = {
		highlight = {lsRanges = true},
		cache = {retainInMemory = 1},
		diagnostics = {
			onOpen = 0,
			onChange = 0,
			onSave = 100
		},
		index = {
			threads = 8
		}
		--compilationDatabaseDirectory = "build/"
	},
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = false
				}
			}
		}
	},
	on_attach = on_attach_vim,
})

end

-- from RishabhRD/nvim-lsputils:
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
-- vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
-- vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

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


-- lua

nvim_lsp.sumneko_lua.setup {
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

nvim_lsp.rust_analyzer.setup {
	on_attach = on_attach_vim,
	cmd = {"/usr/local/bin/rust-analyzer"},
	filetypes = {"rust"},
	root_dir = nvim_lsp.util.root_pattern("Cargo.toml"),
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

nvim_lsp.tsserver.setup {
	filetypes = {"javascript"},
	root_dir = nvim_lsp.util.root_pattern(".git"),
	on_attach = on_attach_vim,
}

-- cmake

nvim_lsp.cmake.setup {}
