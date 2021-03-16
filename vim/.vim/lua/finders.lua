require'telescope'.setup{
	set_env = { ['COLORTERM'] = 'truecolor' }
}

local telescope = require'telescope.builtin'

local grep_cmd_default = {
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
	"-g '!*.dmp'",
	"-E", "*.hex",
	"-E", "*.bin",
	"-E", ".DS_Store",
	"-E", "*.o",
	"-E", "*.d",
}

local find_filename_cmd_default = {
	"fd",
	"--type", "f",
	"--type", "l",
	"--follow",
	"--color=never",
}


local function append_table(a, b)
	local c = {unpack(a)}
	for _,v in ipairs(b) do
		table.insert(c, v)
	end
end

local grep_all_files_cmd = append_table(grep_cmd_default, find_all_files_cmd_extras)
local find_all_files_cmd = append_table(find_filename_cmd_default, find_all_files_cmd_extras)

local M = {
	find_stuff = function()
		telescope.live_grep({vimgrep_arguments = grep_cmd_default})
		end,
	find_stuff_in_dir = function(dir)
		telescope.live_grep({vimgrep_arguments = append_table(grep_cmd_default, {"-g '"..dir.."/**'"})})
		end,
	find_word = function()
		telescope.grep_string({vimgrep_arguments = grep_cmd_default})
		end,
	find_stuff_all_files = function()
		telescope.live_grep({vimgrep_arguments = grep_all_files_cmd})
		end,
	find_word_all_files = function()
		telescope.grep_string({vimgrep_arguments = grep_all_files_cmd})
		end,
	find_file = function()
		telescope.find_files({find_command = find_filename_cmd_default})
		end,
	find_all_files = function()
		telescope.find_files({find_command = find_all_files_cmd})
		end,
}


function M.find_dotfiles()
	-- reloader()
	require('telescope.builtin').find_files {
		find_command = {
			"fd",
			"--type", "f",
			"--type", "l",
			"--hidden",
			"--follow",
			"--no-ignore",
			"--color=never",
			"-E", ".git",
			"-E", ".ccls-cache",
			"-E", ".clangd",
			"-E", ".cache",
			"-E", "*.o",
			"-E", "*.d",
			"-E", ".DS_Store",
			"-E", "cscope*",
			"-E", "tags*",
			"-E", "*.hex",
			"-E", "*.bin"
		},
		hidden = true,
		follow = true,
		-- search_dirs = {"/dot-files/vim/", "~/.config/nvim/"}, -- doesn't work?
		shorten_path = false,
		cwd = "~/dot-files/vim/",
		prompt = "~/dot-files/vim/",
		height = 20,

		layout_strategy = 'horizontal',
		layout_options = {
			preview_width = 0.55,
		},
	}
end

return M

