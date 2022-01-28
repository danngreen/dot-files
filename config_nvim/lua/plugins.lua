local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec(
	[[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua luafile %
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]],
	false
)

vim.g.python3_host_prog = "/usr/local/bin/python3"

local use = require("packer").use
require("packer").startup(
	function()
		use {"wbthomason/packer.nvim", opt = true}
		use {"scrooloose/nerdtree", opt = true, cmd = {"NERDTreeToggle"}}
		use {
			"junegunn/fzf.vim",
			requires = {"junegunn/fzf"},
			rtp = "/usr/local/opt/fzf",
			config = 'vim.cmd("let g:fzf_preview_window = [\'right:50%:nohidden\', \'?\']")'
		}
		use {
			"ibhagwan/fzf-lua",
			requires = {"vijaymarupudi/nvim-fzf", "kyazdani42/nvim-web-devicons"},
			config = function()
				require "fzf-lua-conf".config()
			end
		}
		use {
			"danngreen/monokai.nvim",
			config = function()
				--monokai fork that's not async (so we don't have to integrate all highlights into monokai's syntax)
				require "monokai".setup {}
				require "custom-hi"
			end
		}
		use {
			"danngreen/lualine.nvim",
			config = function()
				require "lualine-conf".config()
			end
		}
		use {"vim-scripts/hexHighlight.vim"}
		--
		-- LSP
		--
		use {"neovim/nvim-lspconfig"}
		use {"nvim-lua/popup.nvim"}
		use {"nvim-lua/plenary.nvim"}
		use {"ray-x/lsp_signature.nvim", config = function() require('lsp_signature').setup({}) end}
		use {"m-pilia/vim-ccls"}
		use {"rust-lang/rust.vim"}
		use {
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/vim-vsnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-calc",
				"uga-rosa/cmp-dictionary",
				"hrsh7th/cmp-cmdline",
			}
		}
		--
		-- Telescope
		--
		use {
			"nvim-lua/telescope.nvim",
			config = function()
				require "telescope_conf".config()
			end
		}
		use {
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
			after = "telescope.nvim",
			config = "require'telescope'.load_extension('fzf')"
		}
		--
		-- Treesitter
		--
		use {
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require "treesitter_conf".config()
			end
		}
		use {"nvim-treesitter/nvim-treesitter-textobjects"}
		use {"nvim-treesitter/playground"}
		use {"nvim-treesitter/nvim-treesitter-refactor"}

		use {"majutsushi/tagbar", config = "vim.g.tagbar_file_size_limit = 400000"}
		use {
			"lukas-reineke/format.nvim",
			config = function()
				require "format".setup {
					--npm i -g lua-fmt
					lua = {{cmd = {"luafmt -l 120 --use-tabs -i 4 -w replace"}}},
					vim = {
						{
							cmd = {"luafmt -w replace"},
							start_pattern = "^lua << EOF$",
							end_pattern = "^EOF$"
						}
					}
				}
			end
		}
		use {"khaveesh/vim-fish-syntax"}

		use {"iamcco/markdown-preview.nvim", run = "call mkdp#util#install()"}
		use {"tpope/vim-eunuch"}
		use {
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
		}
		use {"tpope/vim-dispatch"}
		use {"tpope/vim-fugitive"}
		use {"voldikss/vim-floaterm"}
		use {
			"lewis6991/gitsigns.nvim",
			requires = {"nvim-lua/plenary.nvim"},
			config = function()
				require("gitsigns").setup()
			end
		}

		-- Debugging
		use {'simrat39/rust-tools.nvim', config = function()
			require('rust-tools').setup({})
		end}
		use {
			"mfussenegger/nvim-dap",
			config = function()
				local dap = require("dap")
				dap.adapters.cppdbg = {
					type = "server",
					-- command = '/Users/design/4ms/stm32/nvim-dap-cpptools-osx/extension/debugAdapters/OpenDebugAD7',
					host = "127.0.0.1",
					port = 3333
				}
				dap.configurations.cpp = {
					-- {
					-- 	name = "Launch file",
					-- 	type = "cppdbg",
					-- 	request = "launch",
					-- 	program = function()
					-- 	  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					-- 	end,
					-- 	cwd = '${workspaceFolder}',
					-- 	stopOnEntry = true,
					-- },
					{
						name = "Attach to gdbserver :3333",
						type = "cppdbg",
						request = "launch",
						MIMode = "gdb",
						miDebuggerServerAddress = "localhost:3333",
						miDebuggerPath = "/Users/design/4ms/stm32/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-py",
						cwd = "${workspaceFolder}",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/main.elf", "file")
						end
					}
				}
			end
		}

		--use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
		-- use {'chmanie/termdebugx.nvim', config = function() vim.cmd[[
		-- 	let termdebugger = "arm-none-eabi-gdb-py"
		-- 	let g:termdebug_useFloatingHover = 0
		-- 	let g:termdebug_wide = 140
		-- 	let g:termdebug_disasm_window = 15
		-- 	let g:termdebugger_program = "minicom -D /dev/cu.usbmodem*"
		-- ]] end}
	end
)
