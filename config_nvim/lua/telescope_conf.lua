_M = {}
_M.config = function()
	require "telescope".setup {
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case" -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
			}
		},
		defaults = {
			mappings = {i = {["<esc>"] = require "telescope.actions".close}},
			set_env = {["COLORTERM"] = "truecolor"}
		}
	}
	vim.cmd [[hi TelescopePromptBorder guifg=cyan]]
	vim.cmd [[hi TelescopeMatching guifg=red]]
end

return _M
