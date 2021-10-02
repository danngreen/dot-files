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
	layout_config = {height = 12, width = 0.4},
	preview = 0.9
}

--fzf_files(starting_term, opts) --> general(flatten{extra_grep_terms, starting_term}, opts)
--fzf_filename(opts) -> general({"--files"}, opts)
--remove opts.terms, add opts.prompt_prefix
local fzf_general = function(extra_rg_args, opts)
	opts = opts or {}
	local search_dirs = opts.search_dirs
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

	local find_command = vim.tbl_flatten{ cmd_args, extra_rg_args, search_dirs}

	-- local entry_mk
	if extra_rg_args[1] == '--files' then
		prompt_title = "Searching Filename"
		opts.entry_maker = make_entry.gen_from_file(opts)
	else
		prompt_title = "Searching within files"
		opts.entry_maker = make_entry.gen_from_vimgrep(opts)
	end

	pickers.new(opts, {
		prompt_title = prompt_title,
		finder = finders.new_oneshot_job(find_command, opts),
		previewer = ts_conf.grep_previewer(opts),
		sorter = ts_conf.file_sorter(opts)
	}):find()
end


local M = {
	--Buffers
	buffers = function(opts)
		local _opts = opts or small_center_layout_conf
		telescope.buffers(_opts)
	end,

	fzf_general = fzf_general,

	--Grep
	fzf_files = function(starting_term, opts)
		opts = opts or {}
		local extra_rg_args = vim.tbl_flatten{extra_grep_terms, {starting_term}}
		if starting_term then
			opts.prompt_prefix = "["..starting_term.."] >"
		end
		fzf_general(extra_rg_args, opts)
	end,

	--Filenames
	fzf_filename = function(opts)
		opts = opts or {}
		fzf_general({"--files"}, opts)
	end,


	LS = function(path)
		local cmd = table.concat(find_all_files_cmd, " ")
		vim.cmd([[call fzf#run(fzf#wrap({'source': "]]..cmd..[[", 'dir': ']]..path..[['}, 0))]])
	end,
}

_G.LS = M.LS

return M
