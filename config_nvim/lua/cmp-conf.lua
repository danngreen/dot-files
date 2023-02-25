local _M = {}

local settings = {}
settings.use_snippets = true

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local disable_snippets = function(argsbody)
	-- This disables snippets:
	local line_num, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
	local indent = string.match(line_text, "^%s*")
	local replace = vim.split(argsbody, "\n", true)
	local surround = string.match(line_text, "%S.*") or ""
	local surround_end = surround:sub(col)

	replace[1] = surround:sub(1, col - 1) .. replace[1]
	replace[#replace] = replace[#replace] .. (#surround_end > 1 and " " or "") .. surround_end

	for i, line in ipairs(replace) do
		line = line:gsub("%b()", "(")
		replace[i] = indent .. line
	end
	vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
	vim.api.nvim_win_set_cursor(0, { line_num, col + replace[#replace]:len() })
end

local cmp = require("cmp")

_M.config =
{
	snippet = {
		expand = function(args)
			if (settings.use_snippets) then
				vim.fn["vsnip#anonymous"](args.body)
			else
				disable_snippets(args.body)
			end
		end
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs( -4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<c-space>"] = cmp.mapping.complete(), --starts completion immediately
		["<C-w>"] = cmp.mapping.close(), --closes menu, leaves whatever text was selected in menu
		["<C-e>"] = cmp.mapping.abort(), --do not change the text, close and abort
		["<C-y>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true -- selects the first option if you haven't "entered" the cmp menu
		},
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false -- cancels if you haven't selected anything
		},
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

		["<Tab>"] = cmp.mapping(
			function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif vim.fn["vsnip#available"]() == 1 then
					-- elseif has_words_before() then
					-- 	cmp.complete()
					feedkey("<Plug>(vsnip-expand-or-jump)", "")
				else
					fallback()
				end
			end,
			{ "i", "s" }
		),
		["<S-Tab>"] = cmp.mapping(
			function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif vim.fn["vsnip#jumpable"]( -1) == 1 then
					feedkey("<Plug>(vsnip-jump-prev)", "")
				end
			end,
			{ "i", "s" }
		)
	}),
	sources = {
		{ name = "nvim_lsp",   priority = 9 },
		{ name = "nvim_lua",   priority = 8 },
		-- { name = "nvim_lsp_signature_help" },
		{ name = "buffer",     priority = 7, keyword_length = 3, max_item_count = 10 },
		{ name = "path",       priority = 4 },
		--{name = 'fuzzy_path'},
		{ name = "calc",       priority = 3 },
		--{name = "rg"},
		{ name = "dictionary", priority = 0, keyword_length = 5, keyword_pattern = [[\w\+]], max_item_count = 4 },
	},
	sorting = {
		priority_weight = 1.0,
		comparators = {
			-- compare.score_offset, -- not good at all
			cmp.config.compare.locality,
			cmp.config.compare.recently_used,
			cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
			cmp.config.compare.length,
			cmp.config.compare.offset,
			cmp.config.compare.order,
			cmp.config.compare.scope,
			-- compare.sort_text,
			-- compare.exact,
			-- compare.kind,
		},
	},
	window = {
		documentation = {
			border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
			winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
		},
		completion = {
			border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
			winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
		}
	},
}

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } }
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
		['<Tab>'] = {
			c = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-z>', true, true, true), 'ni', true)
				end
			end
		}
	}),
	sources = cmp.config.sources(
		{ { name = 'path' } },
		{ { name = 'cmdline' } }
	)
})

require("cmp_dictionary").setup({
	dic = {
		["*"] = "/usr/share/dict/words",
	},
	exact = 3,
	-- async = false,
	-- capacity = 5,
	-- debug = false,
})


-- cmp.setup.cmdline(':', {
-- completion = {
--   autocomplete = { false }
--   -- autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged, }
-- },
-- sources = cmp.config.sources(
-- 	{ { name = 'path' } },
-- 	{ { name = 'cmdline' } }
-- )
-- })

-- Missing documentation for nvim-cmp "ConfirmBehavior" and "select" options:
--
-- ConfirmBehavior: what to do if cursor is in middle of a word that already partially matches:
-- Insert: Just insert the selected word, ignore the surroundings
-- Replace: Replace the current surrounding word with the selection
--
-- Example:
-- bool exit_updater = false;
--          |_________________cursor is here (between _ and u)
--
-- User starts completion by hitting c-space
-- User selects "exit_app" from the cmp menu
-- ConfirmBehavior.Insert: result will be:
-- 		bool exit_appupdater = false;
--
-- ConfirmBehavior.Replace: result will be:
-- 		bool exit_app = false;
--
-- select: whether or not to the automatically select the first entry if the user hasn't
-- 		entered the cmp menu. (That is, if you just type and dont hit C-n or C-p or Down or Up)
-- true: select the first entry automatically
-- false: do not select the entry, just close the cmp menu
--
--
return _M
