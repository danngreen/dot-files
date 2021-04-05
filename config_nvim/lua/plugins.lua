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
	-- use {'ton/vim-alternate',
	-- 	config = vim.api.nvim_exec([[
	-- 		let g:AlternateExtensionMappings = [{'.cc':'.hh', '.hh':'.h', '.h':'.hpp', '.hpp':'.cpp', '.cpp':'.cc'}, {'.c':'.h', '.h':'.c'}]
	-- 		let g:AlternatePaths = ['.', '../inc', '../include', '../src', '../Src', '../Inc']
	-- 	]], false)
	-- }

	----Looking good
	use {'tanvirtin/nvim-monokai'}
	use {'romgrk/barbar.nvim', --can't we do config in plugin's native lua?
		config = function() vim.cmd[[
			let bufferline = get(g:, 'bufferline', {})
			let bufferline.animation = v:false
			let bufferline.auto_hide = v:true
			let bufferline.icons = 'numbers'
			let bufferline.icon_separator_active = '⎜'
			let bufferline.icon_separator_inactive = '⎢'
			let bufferline.icon_close_tab = '✖︎ '
			let bufferline.icon_close_tab_modified = '◻︎'
			let bufferline.maximum_padding = 2
		]]
	end }
	use {'hoob3rt/lualine.nvim', config = function()
		require('lualine').setup{
			options = { theme = 'molokai', icons_enabled = false},
			extensions = { 'fzf' , 'fugitive', 'nerdtree'},
			sections = {
				lualine_a = { {'mode', upper = false} },
				lualine_b = { {'branch', icon = '', color = {bg = '#AAAAAA'} } },
				-- lualine_c = { {require'conf.lualine'.smart_filename, color = {fg = '#F0F0F0', gui = 'bold'}},
				lualine_c = { {'filename', shorten = true, full_path = true, color = {fg = '#F0F0F0', gui = 'bold'}},
							  {'diagnostics', sources = {'nvim_lsp'}, color_error = '#FF0000', color_warn = '#FFFF00', color_info='#999999'}
							},
				lualine_x = {'location'},
				lualine_y = {},
				lualine_z = {'progress'},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				-- lualine_c = { {require'conf.lualine'.smart_filename, color = {fg = '#000000', bg= '#808080'} } },
				lualine_c = { {'filename', shorten = true, full_path = true, color = {fg = '#000000', bg= '#808080'} } },
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
				fzy_native = {
					override_generic_sorter = true,
					override_file_sorter = true,
				}
			},
			defaults = {
				mappings = { i = {["<esc>"] = require'telescope.actions'.close } },
				file_sorter = require'telescope.sorters'.get_fzy_sorter,
				generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
				set_env = { ['COLORTERM'] = 'truecolor' },
			}
		}
		end
	}
	use {'nvim-telescope/telescope-fzy-native.nvim', config = "require'telescope'.load_extension('fzy_native')" }
	use {'nvim-telescope/telescope-fzf-writer.nvim', config = "require'telescope'.load_extension('fzf_writer')" }
	use {'hrsh7th/nvim-compe'}
	use {'RishabhRD/popfix'}
	use {'RishabhRD/nvim-lsputils'}
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
		config = function() require'nvim-treesitter.configs'.setup{
				ensure_installed = {"cpp", "python", "rust", "regex", "javascript", "css", "bash", "c", "php"},
				highlight = {
					enable = true,
					custom_captures = {
					  ["template_arg"] = "TSTemplateArg",
					},
				},
				incremental_selection = false,
				indent = false
			}
		end
	}
	use {'nvim-treesitter/playground'}
	use {'majutsushi/tagbar', config = "vim.g.tagbar_file_size_limit = 100000" }

	use {'m-pilia/vim-ccls'}
	use {'rust-lang/rust.vim'}

	-- Helpers
	use {'tpope/vim-eunuch'}
	use {'tpope/vim-commentary', config = vim.api.nvim_exec([[
		augroup commentary_c_cpp_php
			autocmd!
			autocmd FileType c setlocal commentstring=//%s
			autocmd FileType cpp setlocal commentstring=//%s
			autocmd FileType php setlocal commentstring=//%s
		augroup END
	]], false)}
	use {'tpope/vim-dispatch'}
	use {'tpope/vim-fugitive'}
	use {'voldikss/vim-floaterm'}
end)
