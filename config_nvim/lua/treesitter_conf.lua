_M = {}
_M.config = function()
	require "nvim-treesitter.configs".setup {
		ensure_installed = {"cpp", "python", "rust", "regex", "javascript", "css", "bash", "c", "php", "toml"},
		auto_install = true,
		highlight = {
			enable = true,
			custom_captures = {
				["template_arg"] = "TSTemplateArg"
			}
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm"
			}
		},
		indent = false,
		refactor = {
			highlight_definitions = {enable = true},
			highlight_current_scope = {enable = false},
			smart_rename = {enable = true, keymaps = {smart_rename = "<leader>rN"}},
			navigation = {
				enable = true,
				keymaps = {
					goto_definition_lsp_fallback = "gd",
					list_definitions = "gE",
					list_definitions_toc = "g0",
					goto_next_usage = "<a-*>",
					goto_previous_usage = "<a-#>"
				}
			}
		},
		textobjects = {
			select = {
			  enable = true,

			  -- Automatically jump forward to textobj, similar to targets.vim
			  lookahead = true,

			  keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				},
			},
			swap = {
			  enable = true,
			  swap_next = {
				  ["<leader>a"] = "@parameter.inner",
			  },
			  swap_previous = {
				  ["<leader>A"] = "@parameter.inner",
			  },
			},
		},
	}
end

return _M
