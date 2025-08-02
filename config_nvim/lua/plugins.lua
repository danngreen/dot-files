local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.g.localmapleader = ","

--vim.g.python3_host_prog = "/usr/local/bin/python3"

require("lazy").setup({
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function() vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]]) end
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "vijaymarupudi/nvim-fzf", "nvim-tree/nvim-web-devicons" },
		config = function() require("fzf-lua").setup(require("fzf-lua-conf").config) end,
		--opts = require("fzf-lua-conf").config -- Circular dependencies: fzf-lua-conf requires monokai which isn't in search path yet
	},
	{
		"danngreen/monokai.nvim",
		dependencies = { "ibhagwan/fzf-lua" },
		config = function()
			require("monokai").setup { custom_hlgroups = require("custom-hi").groups }
			require("custom-hi").do_hl()
		end
	},
	{
		"danngreen/lualine.nvim",
		opts = require("lualine-conf").config,
	},
	{
		"kylechui/nvim-surround",
		config = true,
	},
	{
		'rcarriga/nvim-notify',
		config = function()
			require("notify").setup({ render = "minimal", stages = "static" })
			vim.notify = require("notify")
		end
	},
	-- {
	-- 	'lewis6991/whatthejump.nvim'
	-- },
	{
		"stevearc/dressing.nvim",
	},
	{
		'MeanderingProgrammer/markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		main = "render-markdown",
		opts = {
			debounce = 200,
			code = {
				style = 'full',
				border = 'thick',
			},
		},
	},

	-- {
	-- 	-- "idanarye/nvim-blunder",
	-- 	"danngreen/nvim-blunder",
	-- 	opts = {
	-- 		formats = {},
	-- 		-- win_cmd = "botright 120 vnew",
	-- 		-- win_cmd = "FloatermNew --position=topright --width=120 --height=20",
	-- 		win_cmd = "vim.api.nvim_open_win(0, true, {relative='win', row=3, col=3, width=120, height=40})",
	-- 		commands_prefix = 'B',
	-- 	},
	-- },

	-- {
	-- 	"chrisgrieser/nvim-early-retirement",
	-- 	config = true,
	-- 	event = "VeryLazy",
	-- },

	-- {
	-- 	'folke/noice.nvim',
	-- 	event = "VimEnter",
	-- 	opts = require("noice-conf").config,
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 		"hrsh7th/nvim-cmp",
	-- 	}
	-- },
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
			-- 'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			icons = {
				button = 'X',
				filetype = { enabled = false }
			},
			focus_on_close = 'previous',
			hide = { current = false },
		},
		-- version = '^1.0.0', -- optional: only update when a new 1.x version is released
	},
	{
		'danngreen/gitgraph.nvim',
		branch = 'experiment',
		dependencies = { 'sindrets/diffview.nvim' },
		opts = {
			symbols = {
				merge_commit = 'M',
				commit = '*',
				fallback_remote_icon = "■"
			},
			format = {
				timestamp = '%d-%m-%Y %H:%M ',
				fields = { 'timestamp', 'hash', 'author', 'message' },
				fields2 = { 'tag', 'branch_name' },
				remotes = {
					{ server = "origin",   icon = "■", highlight = "SpecialKey" },
					{ server = "danngreen",   icon = "■", highlight = "QuickFixLine" },
					{ server = "upstream", icon = "▤", highlight = "QuickFixLine" },
					{ server = "",         icon = "○", highlight = "" },
				},
			},
			hooks = {
				on_select_commit = function(commit)
					vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
					vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
				end,
				on_select_range_commit = function(from, to)
					vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
					vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
				end,
			},
		},
		keys = {
			{
				"<F6>",
				function()
					require('gitgraph').draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},

	--
	-- LSP
	--
	"neovim/nvim-lspconfig",
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"ranjithshegde/ccls.nvim",
	"p00f/clangd_extensions.nvim",
	"rust-lang/rust.vim",

	{
		"hrsh7th/nvim-cmp",
		config = function() require("cmp").setup(require("cmp-conf").config) end,
		dependencies = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"uga-rosa/cmp-dictionary",
			-- "hrsh7th/cmp-cmdline",
			-- "hrsh7th/cmp-nvim-lsp-signature-help",
		}
	},
	{
		"williamboman/mason.nvim",
		config = true
	},
	{
		'rmagatti/goto-preview',
		config = function() require('goto-preview').setup { default_mappings = true } end
	},
	--
	-- Telescope
	--
	-- {
	-- 	"nvim-lua/telescope.nvim",
	-- 	config = function() require("telescope_conf").config() end, --TODO: use opts
	-- 	dependencies = {
	-- 		{
	-- 			"nvim-telescope/telescope-fzf-native.nvim",
	-- 			build = "make",
	-- 			config = function() require 'telescope'.load_extension('fzf') end,
	-- 		},
	-- 	},
	-- },

	-- { --"ptethng/telescope-makefile",
	-- 	"asteroidalaz/telescope-makefile",
	-- 	dependencies = {"akinsho/toggleterm.nvim", tag = '*', config = function() require("toggleterm").setup() end},
	-- 	after = "telescope.nvim",
	-- 	config = function()
	-- 		require'telescope'.load_extension('make')
	-- 		require'telescope-makefile'.setup{ makefile_priority = { '.', 'build/' } }
	-- 	end
	-- },

	--
	-- Treesitter
	--
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function() require("treesitter_conf").config() end --TODO: use opts
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	"nvim-treesitter/playground",
	"nvim-treesitter/nvim-treesitter-refactor",

	{
		"majutsushi/tagbar",
		config = function() vim.g.tagbar_file_size_limit = 400000 end,
	},

	{
		"lukas-reineke/format.nvim",
		config = function() --TODO: use opts
			require "lsp-format".setup {
				--npm i -g lua-fmt
				lua = { { cmd = { "luafmt -l 120 --use-tabs -i 4 -w replace" } } },
				vim = {
					{
						cmd = { "luafmt -w replace" },
						start_pattern = "^lua << EOF$",
						end_pattern = "^EOF$"
					}
				}
			}
		end
	},

	{
		"iamcco/markdown-preview.nvim",
		build = "call mkdp#util#install()"
	},
	{
		"tpope/vim-commentary",
		config = function()
			vim.cmd [[
			augroup commentary_c_cpp_php
				autocmd!
				autocmd FileType c setlocal commentstring=//%s
				autocmd FileType cpp setlocal commentstring=//%s
				autocmd FileType php setlocal commentstring=//%s
			augroup END
			]]
		end
	},
	"tpope/vim-eunuch",
	"tpope/vim-dispatch",
	"tpope/vim-fugitive",
	"voldikss/vim-floaterm",

	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, --function() require("gitsigns").setup() end
	},
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
	{
		'mbbill/undotree',
		config = function()
			vim.cmd([[set undodir=$HOME/.cache/nvim/undotree]])
			vim.cmd([[set undofile]])
		end
	},

	-- Debugging
	{ 'simrat39/rust-tools.nvim', config = true },
	--function() require('rust-tools').setup({}) end },

	{
		'krady21/compiler-explorer.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	{
		'p00f/godbolt.nvim',
		opts = require("godbolt-conf").config,
		-- function() require("godbolt").setup(require('godbolt-conf').config) end
	},

	-- {
	-- 	'puremourning/vimspector',
	-- 	config = function()
	-- 		vim.cmd([[
	-- 	let g:vimspector_sidebar_width = 85
	-- 	let g:vimspector_bottombar_height = 15
	-- 	let g:vimspector_terminal_maxwidth = 70
	-- 	]])
	-- 	end
	-- },
	{ 'fidian/hexmode' },
})
