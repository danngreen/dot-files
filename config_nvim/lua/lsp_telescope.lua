local telescope_utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")

local m = {}

local function gen_diags_from_lsp_loclist(opts)
	opts = opts or {}
	opts.tail_path = vim.F.if_nil(opts.tail_path, true)

	local displayer =
		entry_display.create {
		separator = "▏",
		items = {
			{width = 11},
			{width = 30},
			{remaining = true}
		}
	}

	local make_display = function(entry)
		local filename
		if not opts.hide_filename then
			filename = entry.filename
			if opts.tail_path then
				filename = telescope_utils.path_tail(filename)
			elseif opts.shorten_path then
				filename = telescope_utils.path_shorten(filename)
			end
		end

		-- add styling of entries
		local type = {I = "Information", W = "Warning", E = "Error"}
		local sign = vim.trim(vim.fn.sign_getdefined("LspDiagnosticsSign" .. type[entry.type])[1].text)
		local pos = string.format("%3d:%2d", entry.lnum, entry.col)

		local line_info = {
			table.concat({sign, pos}, " "),
			"LspDiagnostics" .. type[entry.type]
		}

		return displayer {
			line_info,
			entry.text:gsub(".* | ", ""),
			filename
		}
	end

	return function(entry)
		local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

		return {
			valid = true,
			value = entry,
			ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
			display = make_display,
			filename = filename,
			type = entry.type,
			lnum = entry.lnum,
			col = entry.col,
			text = entry.text,
			start = entry.start,
			finish = entry.finish
		}
	end
end

m.show_diagnostics = function(opts)
	opts = opts or {}
	opts.entry_maker = gen_diags_from_lsp_loclist(opts)
	--opts.hide_filename > opts.tail_path > opts.shorten_path
	vim.lsp.diagnostic.set_loclist({open_loclist = false})
	require "telescope.builtin".loclist(opts)
end

--
-- References
--

m.gen_pretty_refs_from_quickfix = function(opts)
	opts = opts or {}
	opts.tail_path = vim.F.if_nil(opts.tail_path, true)

	local displayer =
		entry_display.create {
		separator = " ▏",
		hl_chars = {
			["["] = "TelescopeBorder",
			["]"] = "TelescopeBorder",
			[":"] = "TelescopeBorder",
			["0"] = "TelescopeBorder",
			["1"] = "TelescopeBorder",
			["2"] = "TelescopeBorder",
			["3"] = "TelescopeBorder",
			["4"] = "TelescopeBorder",
			["5"] = "TelescopeBorder",
			["6"] = "TelescopeBorder",
			["7"] = "TelescopeBorder",
			["8"] = "TelescopeBorder",
			["9"] = "TelescopeBorder"
		},
		items = {
			{width = 30},
			{remaining = true}
		}
	}

	local make_display = function(entry)
		local filename
		if not opts.hide_filename then
			filename = entry.filename
			if opts.tail_path then
				filename = telescope_utils.path_tail(filename)
			elseif opts.shorten_path then
				filename = telescope_utils.path_shorten(filename)
			end
		end

		local line_col = table.concat({entry.lnum, entry.col}, ":")
		local filename_and_line = filename .. " [" .. line_col .. "]"

		return displayer {
			{filename_and_line, "Keyword"},
			entry.text:gsub(".* | ", ""):gsub("^%s+", "")
		}
	end

	return function(entry)
		local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

		return {
			valid = true,
			value = entry,
			ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
			display = make_display,
			filename = filename,
			lnum = entry.lnum,
			col = entry.col,
			text = entry.text,
			start = entry.start,
			finish = entry.finish
		}
	end
end

m.pretty_opts = {make_entry = m.gen_pretty_refs_from_quickfix}

-- Usage:
-- require'telescope.builtin'.lsp_references( {make_entry = require'lsp_telescope'.gen_pretty_refs_from_quickfix()} )
-- require'telescope.builtin'.lsp_references( require'lsp_telescope'.pretty_opts )
-- require'lsp_telescope'.pretty_refs()
m.pretty_refs = function(opts)
	opts = opts or {}
	--relative path from pwd?, e.g. src/m4/main.cc
	opts.tail_path = true
	opts.shorten_path = false
	opts.entry_maker = m.gen_pretty_refs_from_quickfix(opts)
	require "telescope.builtin".lsp_references(opts)
end

return m
