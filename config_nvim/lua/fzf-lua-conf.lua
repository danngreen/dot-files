_M = {}

local monokaicolor = function(name)
	local hex = require'monokai'.classic[name]
	return hex:gsub("#(%x%x)(%x%x)(%x%x)", "0x%1,0x%2,0x%3")
end

_M.config = function()
	require'fzf-lua'.setup {
		fzf_bin = 'sk',
		winopts = {
		  fullscreen = false,
		},
		fzf_opts = {
			['--layout'] = 'default', --vs. 'reverse'
		},
		fzf_colors = {
			["fg"] = {"fg", "Normal"},
			["bg"] = { "bg", "Normal" },
			["hl"] = { "fg", "Keyword"}, --"matched"
			["matched_bg"] = {"bg", "Normal"},
			["fg+"] = { "fg", "Pmenu" }, --"fg of current line"
			["bg+"] = { "fg", "LineNr" }, --"bg of current line"
			["hl+"] = { "fg", "Keyword" }, --"current_match"
			["current_match_bg"] = {"fg", "LineNr"},
			--query
			--query_bg
			["info"] = { "fg", "PreProc" },
			["prompt"] = { "fg", "Conditional" },
			["pointer"] = { "fg", "Exception" },
			["marker"] = { "fg", "Keyword" },
			["spinner"] = { "fg", "Label" },
			["header"] = { "fg", "Comment" },
			["gutter"] = { "bg", "Normal" },
		},
		files = {
			cmd = "rg --files --follow -g!lib/u-boot/*",
		},
		grep = {
		--rg --colors [path,line,match,column]:[fg,bg,style]:[color|bold,nobold,underline,nounderline]
		rg_opts="--hidden --column --line-number --no-heading " ..
				"--color=always --smart-case " ..
				"--colors 'path:fg:"..monokaicolor("aqua").."' "..
				"--colors 'path:style:bold' "..
				"--colors 'match:style:underline' "..
				"-g '!{.git,node_modules}/*' ",
			prompt            = 'Rg❯ ',
			input_prompt      = 'Grep For❯ ',
			actions           = { ["ctrl-q"] = false },
		},
	}
end

_M.find_all_files_cmd = [[rg --files --follow --no-ignore --hidden 
	-g!.ccls-cache 
	-g!.cache 
	-g!**/.git 
	-g!**/.undodir 
	-g!tags* 
	-g!cscope* 
	-g!*.dmp 
	-g!*.hex 
	-g!*.bin 
	-g!.DS_Store 
	-g!*.o 
	-g!*.d
]]
return _M
