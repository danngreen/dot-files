local filename_options = {
	expand_relative = true,
	shorten = false,
	full_path = true,
	auto_shorten_winwidth = 84,
	auto_shorten_filenamelen = 300,
	file_status = true,
	omit_prefix_list = {"~/4ms_local/stm32/", "~/4ms/stm32/"}
}

local omit_prefixes_general = function(path, prefix_list)
	if prefix_list == nil then return end
	for _, prefix in ipairs(prefix_list) do
		path = path:gsub("^"..prefix, "")
	end
	return path
end

local function smart_filename(options)
	-- setting defaults
	if options.expand_relative == nil then options.expand_relative = false end
	if options.shorten == nil then options.shorten = true end
	if options.full_path == nil then options.full_path = false end

	if options.auto_shorten_winwidth == nil then options.auto_shorten_winwidth = 84 end
	if options.auto_shorten_filenamelen == nil then options.auto_shorten_filenamelen = 40 end
	if options.file_status == nil then options.file_status = true end

    local data
	if options.expand_relative then
	  data = vim.fn.expand('%:~:.')
	elseif not options.full_path then
      data = vim.fn.expand('%:t')
    elseif options.shorten then
      data = vim.fn.expand('%')
    else
      data = vim.fn.expand('%:p')
    end

	data = omit_prefixes_general(data, options.omit_prefix_list)

    if data == '' then
      data = '[No Name]'
    elseif vim.fn.winwidth(0) <= options.auto_shorten_winwidth or #data > options.auto_shorten_filenamelen then
      data = vim.fn.pathshorten(data)
    end

    if options.file_status then
      if vim.bo.modified then
        data = data .. '[+]'
      elseif vim.bo.modifiable == false then
        data = data .. '[-]'
      end
    end
    return data
end

local smart_filename_lualine = function()
	return smart_filename(filename_options)
end


require('lualine').setup{
	options = { theme = 'molokai', icons_enabled = false},
	extensions = { 'fzf' , 'fugitive', 'nerdtree'},
	sections = {
		lualine_a = { {'mode', upper = true} },
		lualine_b = { {'branch', icon = ''} },
		lualine_c = { 
					  {smart_filename_lualine, color = {fg = '#F0F0F0', gui = 'bold'}},
					  {'diagnostics', sources = {'nvim_lsp'}}
					},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {'progress'},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { {smart_filename_lualine, color = {fg = '#000000', bg= '#808080'} } },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
}

-- return {smart_filename = filename}
-- return {smart_filename = filename, init = function(options) return filename(options) end}
