local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local Terminal = require("toggleterm.terminal").Terminal
local config   = require("telescope-makefile.config")

local function get_targets()
    local data
	local _make_dir
    for _, make_dir in ipairs(config.makefile_priority) do
        local handle = io.popen("make -pRrq -C ".. make_dir .. [[ : 2>/dev/null |
                awk -F: '/^# Files/,/^# Finished Make data base/ {
                    if ($1 == "# Not a target") skip = 1;
                    if ($1 !~ "^[#.\t]") { if (!skip) {if ($1 !~ "^$")print $1}; skip=0 }
                }' 2>/dev/null]])

        if not handle then
            break
        end
        data = handle:read("*a")
        io.close(handle)
		_make_dir = make_dir
        if #data ~= 0 then
            break
        end
    end
    if #data == 0 then
        return
    end
	return _make_dir, vim.split(string.sub(data, 1, #data - 1), '\n')
end

local function run_target(make_dir, cmd)
	if not make_dir then make_dir = "./" end
	local run_term = Terminal:new({
		cmd = "cd " .. make_dir .. " && make " .. cmd[1],
		direction = "horizontal",
		close_on_exit = false,
	})

	run_term:toggle()
end

local telescope_makefile = function(opts)
    local make_dir, targets = get_targets()
    if not targets then
        vim.notify("No make targets")
        return
    end
	-- print(make_dir)
	pickers.new(opts, {
		prompt_title = "Make",
		finder = finders.new_table(targets),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function ()
                actions.close(prompt_bufnr)
				local command = action_state.get_selected_entry()
                if not command then
                    return
                end
				run_target(make_dir, command)
            end)
			return true
		end,
	}):find()
end

return require("telescope").register_extension({
	exports = {
		make = telescope_makefile,
	},
})
