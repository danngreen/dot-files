_M = {}

local fzf_history_dir = vim.fn.expand('~/.cache/fzf_history')

local monokaicolor = function(name)
	local hex = require "monokai".classic[name]
	-- local hex = "123456"
	return hex:gsub("#(%x%x)(%x%x)(%x%x)", "0x%1,0x%2,0x%3")
end

local get_query = function(opts)
	local query = opts.__resume_data.last_query
	query = query and query:gsub(" ", "\\ ")
	if not query or query == "" then
		query = " "
	end
	return query
end

local utils = require("fzf-lua.utils")

local create_keymap_header = function(keymaps)
	local header = [["::]]
	for _, keymap in ipairs(keymaps) do
		-- style from https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/core.lua#L609
		header = header
			.. " "
			.. ([[<%s> to %s]]):format(utils.ansi_codes.yellow(keymap[1]), utils.ansi_codes.red(keymap[2]))
	end
	return header .. [["]]
	--return { ["--header"] = header .. [["]] },
end

local _M = {}

local switchkey = "tab"

local create_switchkey_action = function(fzf_func)
	return {
		[switchkey] = function(_, opts)
			fzf_func({ fzf_opts = { ["--query"] = get_query(opts), }, })
		end,
	}
end

_M.config = {
	winopts = {
		fullscreen = false,
		preview = {
			layout = 'vertical',
			vertical = 'up:50%',
		}
	},
	fzf_opts = {
		["--layout"] = "default", --default vs. 'reverse'
		["--history"] = fzf_history_dir,
	},
	fzf_colors = {
		["fg"] = { "fg", "Normal" },
		["bg"] = { "bg", "Normal" },
		["hl"] = { "fg", "Keyword" }, --"matched"
		["fg+"] = { "fg", "Pmenu" }, --"fg of current line"
		["bg+"] = { "fg", "LineNr" }, --"bg of current line"
		["hl+"] = { "fg", "Keyword" }, --"current_match"
		--query
		--query_bg
		["info"] = { "fg", "PreProc" },
		["prompt"] = { "fg", "Conditional" },
		["pointer"] = { "fg", "Exception" },
		["marker"] = { "fg", "Keyword" },
		["spinner"] = { "fg", "Label" },
		["header"] = { "fg", "Comment" },
		["gutter"] = { "bg", "Normal" }
	},
	previewers = {
		git_diff = {
			-- cmd_deleted     = "git diff --color HEAD --",
			-- cmd_modified    = "git diff --color HEAD",
			-- cmd_untracked   = "git diff --color --no-index /dev/null",
			pager = "delta",
		},
	},
	files = {
		cmd = "rg --files --follow -g'!lib/u-boot/*'",
		fzf_opts = { ["--header"] = create_keymap_header({ { switchkey, "OldFiles" } }) },
		actions = create_switchkey_action(require("fzf-lua").oldfiles),
		-- [switchkey] = function(_, opts)
		-- 	require("fzf-lua").oldfiles({ fzf_opts = { ["--query"] = get_query(opts), }, })
		-- end,
		-- },
	},
	oldfiles = {
		fzf_opts = { ["--header"] = create_keymap_header({ { switchkey, "Files" }, }), },
		actions = create_switchkey_action(require("fzf-lua").files),
		-- actions = {
		-- 	[switchkey] = function(_, opts)
		-- 		require("fzf-lua").files({ fzf_opts = { ["--query"] = get_query(opts), }, })
		-- 	end,
		-- },
	},
	grep = {
		--rg --colors [path,line,match,column]:[fg,bg,style]:[color|bold,nobold,underline,nounderline]
		rg_opts = "--hidden --column --line-number --no-heading --sort-files " ..
		"--color=always --smart-case " ..
		"--colors 'path:fg:" .. monokaicolor("aqua") .. "' " ..
		"--colors 'path:style:bold' " ..
		"--colors 'match:style:underline' " ..
		"-g '!{.git,node_modules}/*' ",
		prompt = "Rg❯ ",
		input_prompt = "Grep For❯ ",
		actions = { ["ctrl-q"] = false }
	}
}
--end

_M.find_all_files_cmd =
[[rg --files --follow --no-ignore --hidden
	-g'!.ccls-cache'
	-g'!.cache'
	-g'!**/.git'
	-g'!**/.undodir'
	-g'!tags*'
	-g'!cscope*'
	-g'!*.dmp'
	-g'!*.hex'
	-g'!*.bin'
	-g'!.DS_Store'
	-g'!*.o'
	-g'!*.d'
]]
return _M
