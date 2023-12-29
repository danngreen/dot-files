local _M = {}

_M.config =
{
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
			["config.lsp.signature.enabled"] = true,
		},
		signature = {
			enabled = false,
		}
	},
	messages = {
		view_search = "notify",
	},
	presets = {
		-- you can enable a preset by setting it to true, or a table that will override the preset config
		-- you can also add custom presets that you can enable/disable with enabled=true
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = false, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim

	},
	-- cmdline = {
	-- 	view = "cmdline_popup",
	-- },
	-- routes = {
	-- 	{
	-- 		filter = { event = "msg_show", kind = "search_count" },
	-- 		opts = { skip = true },
	-- 	},
	-- 	{
	-- 		view = "split",
	-- 		filter = { event = "msg_show", min_height = 20 },
	-- 	},
	-- 	{
	-- 		view = "notify",
	-- 		filter = { event = "msg_show", find = "written" },
	-- 		opts = { skip = true },
	-- 	},
	-- 	{
	-- 		filter = { event = "msg_show", find = "lines" },
	-- 		opts = { skip = true },
	-- 	},
	-- },
}

return _M
