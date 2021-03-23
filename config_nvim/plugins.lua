-- Install packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

local use = require('packer').use
require('packer').startup(function()
	use {'wbthomason/packer.nvim', opt = true}

	--Finding Files
	use {'scrooloose/nerdtree', opt = true, cmd = {'NERDTreeToggle' }}
	use {'junegunn/fzf.vim', rtp = '/usr/local/opt/fzf', run = "vim.g.fzf_preview_window = \"['right:50%:nohidden', '?']\""}
	use {'ton/vim-alternate'}

	----Looking good
	use {'tanvirtin/nvim-monokai'}
	use {'romgrk/barbar.nvim'}
	use {'hoob3rt/lualine.nvim'}
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
				file_sorter =  require'telescope.sorters'.get_fzy_sorter,
				generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
				set_env = { ['COLORTERM'] = 'truecolor' },
			}
		}
		end
	}
	use {'nvim-telescope/telescope-fzy-native.nvim', config = function()
			require'telescope'.load_extension('fzy_native')
		end
	}
	use {'hrsh7th/nvim-compe'}
	use {'RishabhRD/popfix'}
	use {'RishabhRD/nvim-lsputils'}
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use {'nvim-treesitter/playground'}
	use {'majutsushi/tagbar'}

	use {'m-pilia/vim-ccls'}
	use {'rust-lang/rust.vim'}

	-- Tweaks the way I like it
	use {'vimwiki/vimwiki', 
		config = function() vim.g.vimwiki_list = "[{'path': '~/Sync/wiki/', 'syntax': 'markdown'}]" end, 
		run = 'nmap <leader>WW <Plug>VimwikiIndex'
	}
	use {'thaerkh/vim-workspace'}
	use {'tpope/vim-eunuch'}
	use {'tpope/vim-commentary'}
	use {'tpope/vim-dispatch'}
	use {'tpope/vim-fugitive'}
	use {'voldikss/vim-floaterm'}
end)
