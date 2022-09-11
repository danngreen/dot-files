local pickers      = require("telescope.pickers")
local finders      = require("telescope.finders")
local conf         = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions      = require("telescope.actions")
local Terminal     = require("toggleterm.terminal").Terminal
local config       = require("telescope-makefile.config")
local makefile_dir
local function get_targets()
    local make = config.make_bin
    local data
    -- Check GNU or BSD version
    local hndl = io.popen("[[ $(" .. make .. " --version 2>/dev/null) =~ 'GNU' ]] && echo 1 ")
    if not hndl then
        return
    end
    local is_bsd = #hndl:read('*a') == 0
    for _, make_dir in ipairs(config.makefile_priority) do
        makefile_dir = make_dir
        local bsdcmd = make .. " -d g1 -rn -C " .. make_dir .. [[ 2>&1 1>/dev/null |
                awk -F, '/^#\*\*\* Input graph:/,/^$/ {
                    if ($1 ~ "^# "){ 
                        if ($3 ~ "[|]") {
                            gsub(/# /, "", $1);
                            print $1
                        }
                    }
                }' 2>/dev/null]]
        local gnucmd = make .. " -pRrq -C " .. make_dir .. [[ 2>/dev/null |
                awk -F: '/^# Files/,/^# Finished Make data base/ {
                    if ($1 == "# Not a target") skip = 1;
                    if ($1 !~ "^[#.\t]") { if (!skip) {if ($1 !~ "^$")print $1}; skip=0 }
                }' 2>/dev/null]]
        local handle = io.popen(is_bsd and bsdcmd or gnucmd)
        if not handle then
            break
        end
        data = handle:read("*a")
        io.close(handle)
        if #data ~= 0 then
            break
        end
    end
    if #data == 0 then
        return
    end
    local targets = vim.split(string.sub(data, 1, #data - 1), '\n')
     if  config.default_target then
        table.insert(targets, config.default_target)
     end
	 return targets
end

local function run_target(cmd)
    local target = cmd[1] == config.default_target and "" or cmd[1]
    local run_term = Terminal:new({
        cmd = config.make_bin .. " -C " .. makefile_dir .. " " .. target,
        direction = "horizontal",
        close_on_exit = false,
    })

    run_term:toggle()
end

local telescope_makefile = function(opts)
    local targets = get_targets()
    if not targets then
        vim.notify("No make targets")
        return
    end
    pickers.new(opts, {
        prompt_title = "Make",
        finder = finders.new_table(targets),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local command = action_state.get_selected_entry()
                if not command then
                    return
                end
                run_target(command)
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
