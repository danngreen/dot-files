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
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require "cmp"
cmp.setup {
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
			-- This disables snippets:
			-- local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
			-- local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
			-- -- print(vim.inspect(line_text)) -- the line, as-is with indentation, but with the contigious block of non-whitespace characters before the cursor removed
			-- local indent = string.match(line_text, '^%s*')
			-- local replace = vim.split(args.body, '\n', true)
			-- -- print(vim.inspect(replace)) = { "lv_color_make(${1:uint8_t r}, ${2:uint8_t g}, ${3:uint8_t b})" }
			-- local surround = string.match(line_text, '%S.*') or ''
			-- -- local surround = line_text
			-- -- print(vim.inspect(surround)) -- [text before cursor] [text after cursor]
			-- local surround_end = surround:sub(col)
			-- -- print(vim.inspect(surround_end)) --[text after cursor]

			-- replace[1] = surround:sub(1, col - 1)..replace[1]
			-- -- print(vim.inspect(replace)) --not correct: mostly the text before the cursor + inserted text + mangled like it's trying to be "smart" about what to replace
			-- replace[#replace] = replace[#replace]..(#surround_end > 1 and ' ' or '')..surround_end
			-- -- print(vim.inspect(replace)) -- [text after cursor is appended]

			-- for i, line in ipairs(replace) do
			-- line = line:gsub("%b()","(")
			-- replace[i] = indent..line
			-- end
			-- vim.api.nvim_buf_set_lines(0, line_num-1, line_num, true, replace)
			-- vim.api.nvim_win_set_cursor(0, {line_num, col + replace[#replace]:len()})
		end
	},
	mapping = {
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<c-space>"] = cmp.mapping.complete(), --starts completion immediately
		["<C-w>"] = cmp.mapping.close(), --closes menu, leaves whatever text was selected in menu
		["<C-e>"] = cmp.mapping.abort(), --do not change the text, close and abort
		--All these behave the same. WTF does ConfirmBehavior and select do?
		["<C-y>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true
		},
		["<C-u>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = false
		},
		["<CR>"] = cmp.mapping.confirm {
			--this works with vsnip
			behavior = cmp.ConfirmBehavior.Replace,
			select = false
		},
		["<Esc>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false
		},
		["<C-q>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true
		},
		-----

		["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
		["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
		["<Down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
		["<Up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
		--vsnip "Super tab"
		["<Tab>"] = cmp.mapping(
			function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif vim.fn["vsnip#available"]() == 1 then
					feedkey("<Plug>(vsnip-expand-or-jump)", "")
				elseif has_words_before() then
					cmp.complete()
				else
					fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
				end
			end,
			{"i", "s"}
		),
		["<S-Tab>"] = cmp.mapping(
			function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif vim.fn["vsnip#jumpable"](-1) == 1 then
					feedkey("<Plug>(vsnip-jump-prev)", "")
				end
			end,
			{"i", "s"}
		)

		-- "No snippet engine"
		-- ['<C-Space>'] = cmp.mapping.confirm {
		--   behavior = cmp.ConfirmBehavior.Insert,
		--   select = true,
		-- },

		-- ['<Tab>'] = function(fallback)
		--   if not cmp.select_next_item() then
		--     if vim.bo.buftype ~= 'prompt' and has_words_before() then
		--       cmp.complete()
		--     else
		--       fallback()
		--     end
		--   end
		-- end,

		-- ['<S-Tab>'] = function(fallback)
		--   if not cmp.select_prev_item() then
		--     if vim.bo.buftype ~= 'prompt' and has_words_before() then
		--       cmp.complete()
		--     else
		--       fallback()
		--     end
		--   end
		-- end,

		--Luasnip
		-- ['<Tab>'] = cmp.mapping(function(fallback)
		-- if cmp.visible() then cmp.select_next_item()
		-- elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
		-- elseif has_words_before() then cmp.complete()
		-- else fallback() end
		-- end, {"i", "s"}),
		-- ['<S-Tab>'] = cmp.mapping(function(fallback)
		-- if cmp.visible() then cmp.select_prev_item()
		-- elseif luasnip.jumpable(-1) then luasnip.jump(-1)
		-- else fallback() end
		-- end, {"i", "s"}),
	},
	sources = {
		{name = "nvim_lsp"},
		{name = "nvim_lua"},
		{name = "buffer", keyword_length = 5},
		{name = "path"},
		{name = "calc"}
	},
	documentation = {
		maxwidth = 80,
		maxheight = 100
	},
	experimental = {
		native_menu = false --fails
		-- ghost_text = true,
	}
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end
-- local check_back_space = function()
--     local col = vim.fn.col('.') - 1
--     if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then return true
--     else return false
--     end
-- end

-- Formatting

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

-- Diagnostics

local toggle_diags_virtual_text = {}
toggle_diags_virtual_text.show = true
toggle_diags_virtual_text.toggle = function()
	toggle_diags_virtual_text.show = not toggle_diags_virtual_text.show
	vim.diagnostic.config({toggle_diags_virtual_text = toggle_diags_virtual_text.show})
end
conf_lsp.virtual_text = toggle_diags_virtual_text

-- LSP Buffer key maps

local on_attach_vim = function(client, bufnr)
	print("LSP started: " .. client.name)

	local inoremap_cmd = function(k, c)
		vim.api.nvim_buf_set_keymap(bufnr, "i", k, "<cmd>" .. c .. "<CR>", {noremap = true, silent = true})
	end
	local nnoremap_cmd = function(k, c)
		vim.api.nvim_buf_set_keymap(bufnr, "n", k, "<cmd>" .. c .. "<CR>", {noremap = true, silent = true})
	end

	--Symbol info (hover/signature)
	nnoremap_cmd("K", "lua vim.lsp.buf.hover()")
	nnoremap_cmd("<C-k>", "lua vim.lsp.buf.signature_help()")
	inoremap_cmd("<C-k>", "lua vim.lsp.buf.signature_help()")

	require "lsp_signature".on_attach(
		{
			bind = true,
			fix_pos = true,
			always_trigger = false,
			floating_window = false,
			floating_window_above_cur_line = true,
			handler_opts = {border = "single"},
			--toggle_key = '<C-k>',
			hint_enable = false
		},
		bufnr
	)

	--Refs/Defs
	nnoremap_cmd("gd", "lua vim.lsp.buf.definition()")
	-- nnoremap_cmd('gr',			'lua require\'telescope.builtin\'.lsp_references()')
	nnoremap_cmd("gr", "lua require'conf.lsp'.pretty_telescope.pretty_refs()")
	nnoremap_cmd("gD", "lua vim.lsp.buf.declaration()")

	-- if client.resolved_capabilities.type_definition then
	nnoremap_cmd("gi", "lua vim.lsp.buf.type_definition()") --not supported by clangd, but works in ccls
	nnoremap_cmd("gI", "lua vim.lsp.buf.implementation()") --not supported by clangd...
	nnoremap_cmd("gn", "lua vim.lsp.buf.incoming_calls()")
	nnoremap_cmd("gN", "lua vim.lsp.buf.outgoing_calls()")

	--Symbols
	nnoremap_cmd("gw", "Telescope lsp_dynamic_workspace_symbols")
	-- nnoremap_cmd('gw', 			'lua vim.lsp.buf.workspace_symbol()')
	nnoremap_cmd("g0", "lua vim.lsp.buf.document_symbol()")

	nnoremap_cmd("<leader>ff", "lua require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_cursor())")
	-- nnoremap_cmd('<leader>ff', 	'lua vim.lsp.buf.code_action()') --Doesn't work? See comment in handlers below

	nnoremap_cmd("<leader>rn", "lua Rename.rename()")

	--Switch header (replaced with Alternate File)
	nnoremap_cmd("<M-h>", "ClangdSwitchSourceHeader")
	nnoremap_cmd("<leader>h", "ClangdSwitchSourceHeaderVSplit")

	--Diagnostics
	nnoremap_cmd("<leader>e", 'lua vim.diagnostic.open_float(0, {scope="line"})')
	nnoremap_cmd("<leader>E", 'lua vim.diagnostic.open_float(0, {scope="buffer"})')
	nnoremap_cmd("<leader>f]", "lua vim.diagnostic.goto_next()")
	nnoremap_cmd("<leader>f[", "lua vim.diagnostic.goto_prev()")
	nnoremap_cmd("<leader>fp", "lua vim.diagnostic.setloclist()")
	nnoremap_cmd("<leader>fP", "lua vim.diagnostic.setqflist()")
	nnoremap_cmd("<leader>fC", "lua vim.diagnostic.disable(0)")
	nnoremap_cmd("<leader>fc", "lua require'conf.lsp'.toggle_diags_virtual_text.toggle()")

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
		vim.cmd [[autocmd BufWritePre <buffer> lua require'conf.lsp'.lsp_format() ]]
		vim.cmd [[augroup END]]
		vim.cmd [[command! FormatDisable lua FormatSetState(true)]]
		vim.cmd [[command! FormatEnable lua FormatSetState(false)]]
	end
end

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
		bufnr = nvim_lspconfig.util.validate_bufnr(bufnr)
		local params = {uri = vim.uri_from_bufnr(bufnr)}
		vim.lsp.buf_request(
			bufnr,
			"textDocument/switchSourceHeader",
			params,
			nvim_lspconfig.util.compat_handler(
				function(err, result)
					if err then
						error(tostring(err))
					end
					if not result then
						print("Corresponding file can’t be determined")
						return
					end
					vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
				end
			)
		)
	end

	nvim_lspconfig.clangd.setup {
		cmd = {
			"/usr/local/opt/llvm/bin/clangd",
			"--background-index",
			--"--log=verbose",
			"-j=32",
			"--cross-file-rename",
			"--fallback-style=LLVM",
			"--clang-tidy",
			-- "--all-scopes-completion",
			"--header-insertion=iwyu",
			"--header-insertion-decorators", -- just in case somebody tries to turn it on
			"--completion-style=bundled",
			"--query-driver=**/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-*",
			"--query-driver=/usr/local/bin/arm-none-eabi-g*",
			"--query-driver=/Users/dann/4ms/stm32/gcc-arm-none-eabi-*/bin/arm-none-eabi-*",
			"--query-driver=/Users/design/4ms/stm32/gcc-arm-none-eabi-*/bin/arm-none-eabi-*",
			"--query-driver=/usr/bin/g*",
			"--pch-storage=memory",
			"--enable-config"
		},
		filetypes = {"c", "cpp"},
		root_dir = nvim_lspconfig.util.root_pattern(".clangd", "compile_commands.json"),
		on_attach = on_attach_vim,
		capabilities = capabilities,
		-- capabilities = { textDocument = { completion = { completionItem = { snippetSupport = true } } } },
		-- capabilities = (function()
		--   local clangd_capabilities = capabilities
		--   clangd_capabilities.textDocument.completion.completionItem.snippetSupport = false
		--   return capabilities
		-- end)(),

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
	cmd = {"/usr/local/bin/rust-analyzer"},
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

nvim_lspconfig.cmake.setup {}

-- html

nvim_lspconfig.html.setup {
	cmd = {"/usr/local/bin/html-languageserver", "--stdio"},
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
