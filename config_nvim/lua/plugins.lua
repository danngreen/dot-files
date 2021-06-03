-- Install packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua luafile %
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

vim.g.python3_host_prog = '/usr/local/bin/python3'

local use = require('packer').use
require('packer').startup(function()
	use {'wbthomason/packer.nvim', opt = true}

	--Finding Files
	use {'scrooloose/nerdtree', opt = true, cmd = {'NERDTreeToggle' }}
	use {'junegunn/fzf.vim',
		requires = {'junegunn/fzf'},
		rtp = '/usr/local/opt/fzf',
		config = "vim.cmd(\"let g:fzf_preview_window = ['right:50%:nohidden', '?']\")"
	}

	----Looking good
	use {'tanvirtin/nvim-monokai'}
	use {'danngreen/lualine.nvim', config = function() --forked from hoob3rt/lualine.nvim
		require('lualine').setup{
			options = { theme = 'molokai', icons_enabled = false},
			extensions = { 'fzf' , 'fugitive', 'nerdtree'},
			sections = {
				lualine_a = { {'mode', upper = false} },
				lualine_b = { {'branch', icon = '', color = {bg = '#AAAAAA'} } },
				lualine_c = { {'filename', shorten = true, full_path = true, max_filename_length = 100, narrow_window_size = 84, color = {fg = '#F0F0F0', gui = 'bold'}},
							  {'diagnostics', sources = {'nvim_lsp'}, color_error = '#FF0000', color_warn = '#FFFF00', color_info='#999999'}
							},
				lualine_x = {'location'},
				lualine_y = {},
				lualine_z = {'progress'},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { {'filename', shorten = true, full_path = true, max_filename_length = 100, narrow_window_size = 84, color = {fg = '#000000', bg= '#808080'} } },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		}
	end }
	use {'vim-scripts/hexHighlight.vim'}

	-- Navigating code
	use {'neovim/nvim-lspconfig'}
	use {'nvim-lua/popup.nvim'}
	use {'nvim-lua/plenary.nvim'}
	use {'nvim-lua/telescope.nvim', config = function()
		require'telescope'.setup{
			extensions = {
				fzf = {
				  override_generic_sorter = false, -- override the generic sorter
				  override_file_sorter = true,     -- override the file sorter
				  case_mode = "smart_case",        -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
				}
			},
			defaults = {
				mappings = { i = {["<esc>"] = require'telescope.actions'.close } },
				set_env = { ['COLORTERM'] = 'truecolor' },
			}
		}
		end
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make', after = 'telescope.nvim', config = "require'telescope'.load_extension('fzf')" }

	use {'hrsh7th/nvim-compe'}
	use {'ray-x/lsp_signature.nvim'}
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
		config = function() require'nvim-treesitter.configs'.setup{
				ensure_installed = {"cpp", "python", "rust", "regex", "javascript", "css", "bash", "c", "php"},
				highlight = {
					enable = true,
					custom_captures = {
					  ["template_arg"] = "TSTemplateArg",
					},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				indent = false,
				refactor = {
					highlight_definitions = { enable = true },
					highlight_current_scope = { enable = false },
					smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
					navigation = { enable = true,
						keymaps = {
							goto_definition_lsp_fallback = "gd",
							list_definitions = "gD",
							list_definitions_toc = "gO",
							goto_next_usage = "<a-*>",
							goto_previous_usage = "<a-#>",
						},
					},
				},
			}
		end
	}
	use {'nvim-treesitter/playground'}
	use {'nvim-treesitter/nvim-treesitter-refactor'}
	use {'majutsushi/tagbar', config = "vim.g.tagbar_file_size_limit = 100000" }

	use {'m-pilia/vim-ccls'}
	use {'rust-lang/rust.vim'}
	use {'michaelb/sniprun', run = 'bash install.sh 1'}
	use {'iamcco/markdown-preview.nvim', run = 'call mkdp#util#install()'}

	-- Helpers
	use {'tpope/vim-eunuch'}
	use {'tpope/vim-commentary', config = vim.cmd[[
		augroup commentary_c_cpp_php
			autocmd!
			autocmd FileType c setlocal commentstring=//%s
			autocmd FileType cpp setlocal commentstring=//%s
			autocmd FileType php setlocal commentstring=//%s
		augroup END
	]]}
	use {'tpope/vim-dispatch'}
	use {'tpope/vim-fugitive'}
	use {'voldikss/vim-floaterm'}
	-- use {'gennaro-tedesco/nvim-peekup', config = function()
	-- 	require'nvim-peekup'.on_keystroke = {
	-- 		delay = '50ms',
	-- 		autoclose = true,
	-- 		paste_reg = '"',
	-- 	} end
	-- }
	use {'chmanie/termdebugx.nvim', config = function() vim.cmd[[
		let termdebugger = "arm-none-eabi-gdb-py"
		let g:termdebug_useFloatingHover = 0
		let g:termdebug_wide = 140
		let g:termdebug_disasm_window = 15
		let g:termdebugger_program = "minicom -D /dev/cu.usbmodem*"
	]] end}
end)

