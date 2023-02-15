_M = {}

_M.config =
-- function() require("lualine").setup
{
	options = { theme = "molokai", icons_enabled = false },
	extensions = { "fzf", "fugitive", "nerdtree" },
	sections = {
		lualine_a = { { "mode", upper = false } },
		lualine_b = { { "branch", icon = "", color = { bg = "#AAAAAA" } } },
		lualine_c = {
			{
				"filename",
				path = 1,
				shorten = true,
				full_path = true,
				max_filename_length = 100,
				narrow_window_size = 84,
				color = { fg = "#F0F0F0", gui = "bold" }
			},
			{ "diagnostics", sources = { "nvim_diagnostic" }, color_error = "#FF0000", color_warn = "#FFFF00", color_info = "#999999" }
		},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = { "progress" }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				path = 1,
				shorten = true,
				full_path = true,
				max_filename_length = 100,
				narrow_window_size = 84,
				color = { fg = "#000000", bg = "#808080" }
			}
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	}
}
-- end

return _M
