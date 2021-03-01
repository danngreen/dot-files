local telescope = require'telescope.builtin'

local find_cmd_default = {
	"rg",
	"--color=never",
	"--no-heading",
	"--with-filename",
	"--line-number",
	"--column",
	"--smart-case",
	"--follow"
}

local find_all_files_cmd_extras = {
	"--hidden",
	"--no-ignore",
	"-g '!.ccls-cache'",
	"-g '!.*cache/*'",
	"-g '!.git/*'",
	"-g '!tags*'",
	"-g '!cscope*'",
	"-g '!compile_commands.json'",
	"-g '!*.map'",
	"-g '!*.dmp'"
}

local find_all_files_cmd = {unpack(find_cmd_default)}
for _,v in ipairs(find_all_files_cmd_extras) do
	table.insert(find_all_files_cmd, v)
end

local M = {
	find_stuff = function()
		telescope.live_grep({vimgrep_arguments = find_cmd_default})
		end,
	find_word = function()
		telescope.grep_string({vimgrep_arguments = find_cmd_default})
		end,
	find_stuff_all_files = function()
		telescope.live_grep({vimgrep_arguments = find_all_files_cmd})
		end,
	find_word_all_files = function()
		telescope.grep_string({vimgrep_arguments = find_all_files_cmd})
		end
}
return M

