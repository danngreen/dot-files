require'telescope'.setup{
	set_env = { ['COLORTERM'] = 'truecolor' }
}

local telescope = require'telescope.builtin'

local grep_cmd = {
	"rg",
	"--color=never",
	"--no-heading",
	"--with-filename",
	"--line-number",
	"--column",
	"--smart-case",
	"--follow"
}

local grep_all_files_cmd = {
	"rg",
	"--color=never",
	"--no-heading",
	"--with-filename",
	"--line-number",
	"--column",
	"--smart-case",
	"--follow",
	"--hidden",
	"--no-ignore",
	"-g '!.ccls-cache'",
	"-g '!.cache'",
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

local find_cmd = {
	"fd",
	"--type", "f",
	"--type", "l",
	"--follow",
	"--color=never",
}

local find_all_files_cmd = {
	"fd",
	"--type", "f",
	"--type", "l",
	"--follow",
	"--hidden",
	"--no-ignore",
	"-E.ccls-cache",
	"-E.cache",
	"-E.git/*",
	"-E**/.git",
	"-Etags*",
	"-Ecscope*",
	"-Ecompile_commands.json",
	"-E*.map",
	"-E*.dmp",
	"-E*.hex",
	"-E*.bin",
	"-E.DS_Store",
	"-E*.o",
	"-E*.d",
}

local function append_table(a, b)
	local c = {unpack(a)}
	for _,v in ipairs(b) do
		table.insert(c, v)
	end
	return c
end

local M = {
	buffers = function()
		telescope.buffers({
			layout_strategy = "center",
			results_height = 12,
			width = 0.4,
			preview = 0.9
		})
	end,
	find_stuff = function()
		telescope.live_grep({vimgrep_arguments = grep_cmd})
	end,
	find_stuff_in_dir = function(dir) --doesn't work
		telescope.live_grep({vimgrep_arguments = append_table(grep_cmd, {"-g", " '"..dir.."/**'"})})
	end,
	find_word = function()
		telescope.grep_string({vimgrep_arguments = grep_cmd})
		end,
	find_stuff_all_files = function()
		telescope.live_grep({vimgrep_arguments = grep_all_files_cmd})
		end,
	find_word_all_files = function()
		telescope.grep_string({vimgrep_arguments = grep_all_files_cmd})
		end,
	find_file = function()
		telescope.find_files({find_command = find_cmd})
		end,
	find_all_files = function()
		telescope.find_files({find_command = find_all_files_cmd})
		end,

	find_files_in_dir = function(path)
		-- require'telescope'.extensions.fzf_writer.files{
		telescope.find_files {
			find_command = find_all_files_cmd,
			shorten_path = false,
			cwd = path,
			prompt = path,
			height = 20,
			layout_strategy = 'horizontal',
			layout_options = { preview_width = 0.55 },
			-- search_dirs = {"/dot-files/vim/", "~/.config/nvim/"}, -- doesn't work?
		}
	end,

	LS = function(path)
		local cmd = table.concat(find_all_files_cmd, " ")
		vim.cmd([[call fzf#run(fzf#wrap({'source': "]]..cmd..[[", 'dir': ']]..path..[['}, 0))]])
	end
}

_G.LS = M.LS

return M
