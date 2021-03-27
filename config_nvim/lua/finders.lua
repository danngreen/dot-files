local make_entry = require'telescope.make_entry'
local telescope = require'telescope.builtin'
local Job = require('plenary.job')
local finders = require'telescope.finders'
local pickers = require'telescope.pickers'
local ts_conf = require('telescope.config').values

require'telescope'.setup{
	set_env = { ['COLORTERM'] = 'truecolor' }
}

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
	"-g", "!.ccls-cache",
	"-g", "!.cache",
	"-g", "!.git/*",
	"-g", "!tags*",
	"-g", "!cscope*",
	"-g", "!compile_commands.json",
	"-g", "!*.map",
	"-g", "!*.dmp",
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
	"-E**/.undodir",
	"-Etags*",
	"-Ecscope*",
	"-E*.dmp",
	"-E*.hex",
	"-E*.bin",
	"-E.DS_Store",
	"-E*.o",
	"-E*.d",
}

local find_normal_files_rg = { "rg", "--follow" }
local find_all_files_rg = {
	"rg",
	"--hidden",
	"--no-ignore",
	"--follow",
	"-g", "!.ccls-cache",
	"-g", "!.cache",
	"-g", "!**/.git",
	"-g", "!**/.undodir",
	"-g", "!tags*",
	"-g", "!cscope*",
	"-g", "!*.dmp",
	"-g", "!*.hex",
	"-g", "!*.bin",
	"-g", "!.DS_Store",
	"-g", "!*.o",
	"-g", "!*.d",
}

local function append_table(a, b)
	local c = {unpack(a)}
	for _,v in ipairs(b) do
		table.insert(c, v)
	end
	return c
end

local small_center_layout_conf = {
	layout_strategy = "center",
	results_height = 12,
	width = 0.4,
	preview = 0.9
}

local M = {
	--Buffers
	buffers = function(opts)
		local _opts = opts or small_center_layout_conf
		telescope.buffers(_opts)
	end,

	--Grep
	find_stuff = function()
		telescope.live_grep({vimgrep_arguments = grep_cmd})
	end,
	find_stuff_in_dir = function(dir) --doesn't work
		telescope.live_grep({vimgrep_arguments = append_table(grep_cmd, {"-g", " '"..dir.."/**'"})})
	end,
	find_word = function()
		telescope.grep_string({vimgrep_arguments = grep_cmd})
	end,
	find_stuff_all_files = function() --doesn't work?
		telescope.live_grep({vimgrep_arguments = grep_all_files_cmd})
	end,
	find_word_all_files = function() -- doesn't work?
		telescope.grep_string({vimgrep_arguments = grep_all_files_cmd})
	end,

	--Files
	find_file = function()
		telescope.find_files({find_command = find_cmd})
	end,
	find_all_files = function()
		telescope.find_files({find_command = find_all_files_cmd})
	end,

	find_files_in_dir = function(path, opts)
		local _opts = opts or {
			shorten_path = false,
			prompt = "In Dir "..path,
			height = 20,
			layout_strategy = 'horizontal',
			layout_options = { preview_width = 0.55 },
		}
		_opts.cwd = path
		_opts.find_command = find_all_files_cmd
		telescope.find_files(_opts)
	end,

	fzf_filename = function(opts)
		opts = opts or {}
		local search_dirs = opts.search_dirs
		local min_chars = opts.min_chars or 0
		local cmd_args = find_normal_files_rg
		if opts.all then
			cmd_args = find_all_files_rg
		end

		local prompt_title = "Fzf filenames"
		if search_dirs then
			prompt_title = prompt_title.." in "
			for k,v in pairs(search_dirs) do
				prompt_title = prompt_title..v..": "
				search_dirs[k] = vim.fn.expand(v)
			end
			if #search_dirs == 1 then
				opts.cwd = opts.cwd or search_dirs[1]
			end
		end

		local rg_args = vim.tbl_flatten{ cmd_args, {"--files"}, search_dirs }
		table.remove(rg_args, 1)

		local live_grepper = finders._new {
			fn_command = function(_, prompt)
				if #prompt < min_chars then
					return nil
				end
				return {
					writer = Job:new {
						command = "rg",
						args = rg_args
					},
					command = 'fzf',
					args = {'--filter', prompt}
				}
			end,
			--Todo: for k,v in pairs(opts.search_dirs) do filename = filename:gsub("^"..v, "["..k.."]/") end
			entry_maker = make_entry.gen_from_file(opts),
		}

		pickers.new(opts, {
			prompt_title = prompt_title,
			finder = live_grepper,
			previewer = ts_conf.grep_previewer(opts),
			-- sorter = use_highlighter and sorters.highlighter_only(opts),
		}):find()
	end,

	LS = function(path)
		local cmd = table.concat(find_all_files_cmd, " ")
		vim.cmd([[call fzf#run(fzf#wrap({'source': "]]..cmd..[[", 'dir': ']]..path..[['}, 0))]])
	end
}

_G.LS = M.LS

return M
