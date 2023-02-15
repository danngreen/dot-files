local _M = {}

_M.config = 
{
	cmdline = {
	    view = "cmdline_popup",
	},

    routes = {
		{
		    filter = { event = "msg_show", kind = "search_count" },
		    opts = { skip = true },
		},
		{
		    view = "split",
		    filter = { event = "msg_show", min_height = 20 },
		},
		{
			view = "notify",
			filter = { event = "msg_show", find = "written" },
			opts = { skip = true },
		},
		{
			filter = { event = "msg_show", find = "lines" },
			opts = { skip = true },
		},
  },
}

return _M
