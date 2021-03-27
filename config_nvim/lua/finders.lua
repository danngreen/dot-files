local make_entry = require'telescope.make_entry'
local telescope = require'telescope.builtin'
local Job = require('plenary.job')
local finders = require'telescope.finders'
local pickers = require'telescope.pickers'
local ts_conf = require('telescope.config').values
local sorters = require('telescope.sorters')

require'telescope'.setup{
	set_env = { ['COLORTERM'] = 'truecolor' }
}

local use_highlighter = true

local extra_grep_terms = {
	'--no-heading',
	'--with-filename',
	'--line-number',
	'--column',
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
	fzf_files = function(opts)
		opts = opts or {}
		--Note: highly recommended to supply opts.terms for large directories
		local starting_terms = opts.terms
		local search_dirs = opts.search_dirs
		local min_chars = opts.min_chars or 0
		local cmd_args = find_normal_files_rg
		if opts.all then
			cmd_args = find_all_files_rg
		end

		local prompt_title = "Fzf"
		if search_dirs then
			prompt_title = prompt_title.." in "
			for k,v in pairs(search_dirs) do
				prompt_title = prompt_title..v..": "
				search_dirs[k] = vim.fn.expand(v)
			end
			if #search_dirs == 1 then
				opts.cwd = opts.cwd or search_dirs[1]
			end
		else
			search_dirs = {"."}
		end

		local rg_args = vim.tbl_flatten{ cmd_args, extra_grep_terms, starting_terms, search_dirs}
		table.remove(rg_args, 1)
		print(vim.inspect(rg_args))

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
			entry_maker = make_entry.gen_from_vimgrep(opts),
		}

		pickers.new(opts, {
			prompt_title = prompt_title,
			finder = live_grepper,
			previewer = ts_conf.grep_previewer(opts),
			sorter = use_highlighter and sorters.highlighter_only(opts),
		}):find()

	end,

	--Filenames
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

		local fzf_finder = finders._new {
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
			finder = fzf_finder,
			previewer = ts_conf.grep_previewer(opts),
			sorter = use_highlighter and sorters.highlighter_only(opts),
		}):find()
	end,

	LS = function(path)
		local cmd = table.concat(find_all_files_cmd, " ")
		vim.cmd([[call fzf#run(fzf#wrap({'source': "]]..cmd..[[", 'dir': ']]..path..[['}, 0))]])
	end
}

_G.LS = M.LS

return M
