if (vim == nil) then vim = {}; end
local nvim_lspconfig = require'lspconfig'

local conf_lsp = {}
-- require('plenary.reload').reload_module("lsp_telescope")
conf_lsp.pretty_telescope = require'lsp_telescope'

local useclangd = true
local useccls = false

-- Completion
local cmp=require'cmp'
cmp.setup{
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
	  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
	  ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false, --Esc = merge selection with existing, CR = insert selection
      })
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
    },
	documentation = {
		maxwidth=80,
		maxheight=100,
	}
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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

-- LSP Buffer key maps

local on_attach_vim = function(client, bufnr)
	print("LSP started: "..client.name);

	local inoremap_cmd = function(k, c) vim.api.nvim_buf_set_keymap(bufnr, 'i', k, '<cmd>'..c..'<CR>', {noremap = true, silent = true}) end
	local nnoremap_cmd = function(k, c) vim.api.nvim_buf_set_keymap(bufnr, 'n', k, '<cmd>'..c..'<CR>', {noremap = true, silent = true}) end

	--Symbol info (hover/signature)
	nnoremap_cmd('K', 			'lua vim.lsp.buf.hover()')
	-- nnoremap_cmd('<C-k>', 		'lua vim.lsp.buf.signature_help()')
	-- inoremap_cmd('<C-k>', 		'lua vim.lsp.buf.signature_help()')

	require"lsp_signature".on_attach({
      bind = true,
	  floating_window = true,
	  floating_window_above_cur_line = true,
      handler_opts = { border = "single" },
      toggle_key = '<C-k>',
	  hint_enable = false,
    }, bufnr)

	--Refs/Defs
	nnoremap_cmd('gd', 			'lua vim.lsp.buf.definition()')
	nnoremap_cmd('gr',			'lua require\'telescope.builtin\'.lsp_references()')
	nnoremap_cmd('gr',			'lua require\'conf.lsp\'.pretty_telescope.pretty_refs()')
	-- nnoremap_cmd('gD', 	 		'lua vim.lsp.buf.declaration()')

	-- if client.resolved_capabilities.type_definition then
	nnoremap_cmd('gi', 			'lua vim.lsp.buf.type_definition()') --not supported by clangd, but works in ccls
	nnoremap_cmd('gI', 			'lua vim.lsp.buf.implementation()') --not supported by clangd...
	nnoremap_cmd('gn', 			'lua vim.lsp.buf.incoming_calls()')
	nnoremap_cmd('gN', 			'lua vim.lsp.buf.outgoing_calls()')

	--Symbols
	nnoremap_cmd('gw', 			'Telescope lsp_dynamic_workspace_symbols')
	-- nnoremap_cmd('gw', 			'lua vim.lsp.buf.workspace_symbol()')
	nnoremap_cmd('g0', 			'lua vim.lsp.buf.document_symbol()')

	nnoremap_cmd('<leader>ff', 	'lua vim.lsp.buf.code_action()')
	nnoremap_cmd('<leader>rn', 'lua Rename.rename()')

	--Switch header (replaced with Alternate File)
	nnoremap_cmd('<M-h>',		'ClangdSwitchSourceHeader')
	nnoremap_cmd('<leader>h', 	'ClangdSwitchSourceHeaderVSplit')

	--Diagnostics
	nnoremap_cmd('<leader>e', 	'lua vim.lsp.diagnostic.show_line_diagnostics()')
	nnoremap_cmd('<leader>f[', 	'lua vim.lsp.diagnostic.goto_next()')
	nnoremap_cmd('<leader>f]', 	'lua vim.lsp.diagnostic.goto_prev()')
	nnoremap_cmd('<leader>fp', 	'lua vim.lsp.diagnostic.set_loclist()')

	-- Temporarily disable diagnostics (virt text, signs, etc)
	nnoremap_cmd('<leader>fC', 'lua vim.lsp.diagnostic.clear(0)')
	-- Toggle virtual text diagnostics
	nnoremap_cmd('<leader>fc', 'lua require\'conf.lsp\'.virtual_text.toggle()')

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

end

-- Handlers

vim.lsp.handlers['textDocument/codeAction'] = function(opts)
	opts = opts or {}
	opts.layout_config = {height = 7, width=0.3}
	require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_cursor(opts))
end

vim.lsp.handlers['workspace/symbol'] = require'telescope.builtin'.lsp_dynamic_workspace_symbols
vim.lsp.handlers['textDocument/documentSymbol'] = require'telescope.builtin'.lsp_document_symbols

-- From https://www.reddit.com/r/neovim/comments/nsfv7h/rename_in_floating_window_with_neovim_lsp/
local function dorename(win)
  local new_name = vim.trim(vim.fn.getline('.'))
  vim.api.nvim_win_close(win, true)
  vim.lsp.buf.rename(new_name)
end

local function rename()
  local opts = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = 30,
    height = 1,
    style = 'minimal',
    border = 'single'
  }
  local cword = vim.fn.expand('<cword>')
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  local fmt =  '<cmd>lua Rename.dorename(%d)<CR>'
  local cancel = '<cmd>lua vim.api.nvim_win_close(%d, true)<CR>'

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cword})
  vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', string.format(fmt, win), {silent=true})
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', string.format(fmt, win), {silent=true})
  vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', string.format(cancel, win), {silent=true})
end
_G.Rename = {
   rename = rename,
   dorename = dorename
}


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
   vim.lsp.handlers.hover, { border = "single" }
 )

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
   vim.lsp.handlers.signature_help, { border = "single" }
 )

-- Clangd

if (useclangd) then

local function switch_source_header_splitcmd(bufnr, splitcmd)
	bufnr = nvim_lspconfig.util.validate_bufnr(bufnr)
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	vim.lsp.buf_request(
		bufnr,
		'textDocument/switchSourceHeader',
		params,
		nvim_lspconfig.util.compat_handler(function(err, result)
			if err then error(tostring(err)) end
			if not result then print ("Corresponding file can’t be determined") return end
			vim.api.nvim_command(splitcmd..' '..vim.uri_to_fname(result))
		end)
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
		"--completion-style=bundled",
		"--query-driver=/Users/dann/.espressif/tools/xtensa-esp32-elf/esp-2019r2-8.2.0/xtensa-esp32-elf/bin/xtensa-esp32-elf-*",
		"--query-driver=/usr/local/bin/arm-none-eabi-g*",
		"--query-driver=/Users/dann/4ms/stm32/gcc-arm-none-eabi-*/bin/arm-none-eabi-*",
		"--query-driver=/Users/design/4ms/stm32/gcc-arm-none-eabi-*/bin/arm-none-eabi-*",
		"--query-driver=/usr/bin/g*",
		"--pch-storage=memory",
		"--enable-config"
	},
	filetypes = {"c", "cpp"},
	root_dir = nvim_lspconfig.util.root_pattern(".clangd", "compile_commands.json" ),
	on_attach = on_attach_vim,
	capabilities = capabilities,
	-- capabilities = { textDocument = { completion = { completionItem = { snippetSupport = true } } } },

	on_init = function(client)
          client.config.flags.allow_incremental_sync = true
          client.config.flags.debounce_text_changes = 100
    end,

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

-- ccls

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

-- Lua

nvim_lspconfig.sumneko_lua.setup {
	require'conf.lua-lsp',
	cmd = {"/Users/dann/bin/lua-language-server/bin/macOS/lua-language-server", "-E", "/Users/dann/bin/lua-language-server/main.lua"},

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
      return cargo_root or
        nvim_lspconfig.util.find_git_ancestor(fname) or
        nvim_lspconfig.util.root_pattern("rust-project.json")(fname) or
        nvim_lspconfig.util.root_pattern("Cargo.toml")(fname)
    end,

	settings = {
		["rust-analyzer"] = {
			-- cargo = {
			-- 	target = "thumbv7m-none-eabi"
			-- },
			-- checkOnSave = {
			-- 	all_targets = false
			-- }
		}
	},
    capabilities = (function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }
      return capabilities
    end)()
}

-- tsserver/javascript

nvim_lspconfig.tsserver.setup {
	filetypes = {"javascript"},
	root_dir = nvim_lspconfig.util.root_pattern(".git"),
	on_attach = on_attach_vim,
}

-- cmake

nvim_lspconfig.cmake.setup {}

-- html

nvim_lspconfig.html.setup{
	cmd = { "/usr/local/bin/html-languageserver", "--stdio" },
    filetypes = { "html" },
    init_options = {
      configurationSection = { "html", "css", "javascript" },
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
vim.api.nvim_set_keymap('n', '<leader>lss','<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>', {noremap=true})
--Show debug info
vim.api.nvim_set_keymap('n', '<leader>lsI','<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>', {noremap=true})
--Show log
vim.api.nvim_set_keymap('n', '<leader>lsL','<cmd>lua vim.api.nvim_command("e "..vim.lsp.get_log_path())<CR>', {noremap=true})
--Show completion characters
vim.api.nvim_set_keymap('n', '<leader>lsC','<cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities.completionProvider.triggerCharacters))<CR>', {noremap=true})
--Show current symbol type (useful for completion chain list)
vim.api.nvim_set_keymap('n', '<leader>lsc','<cmd>echo synIDattr(synID(line(\'.\'), col(\'.\'), 1), "name")<CR>', {noremap=true})


-- scratch pad

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
