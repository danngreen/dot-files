--Todo: fork lualine and integrate this into the plugin
-- new setup options: expand_relative, auto_shorten_winwidth, auto_shorten_filenamelen, omit_prefix_list
-- local filename_options = {
-- 	expand_relative = true,
-- 	shorten = false,
-- 	full_path = true,
-- 	auto_shorten_winwidth = 84,
-- 	auto_shorten_filenamelen = 300,
-- 	file_status = true,
-- 	omit_prefix_list = {"~/4ms_local/stm32/", "~/4ms/stm32/"}
-- }

-- local omit_prefixes_general = function(path, prefix_list)
-- 	if prefix_list == nil then return end
-- 	for _, prefix in ipairs(prefix_list) do
-- 		path = path:gsub("^"..prefix, "")
-- 	end
-- 	return path
-- end

-- local function smart_filename(options)
-- 	-- setting defaults
-- 	if options.expand_relative == nil then options.expand_relative = false end
-- 	if options.shorten == nil then options.shorten = true end
-- 	if options.full_path == nil then options.full_path = false end

-- 	if options.auto_shorten_winwidth == nil then options.auto_shorten_winwidth = 84 end
-- 	if options.auto_shorten_filenamelen == nil then options.auto_shorten_filenamelen = 40 end
-- 	if options.file_status == nil then options.file_status = true end

--     local data
-- 	if options.expand_relative then
-- 	  data = vim.fn.expand('%:~:.')
-- 	elseif not options.full_path then
--       data = vim.fn.expand('%:t')
--     elseif options.shorten then
--       data = vim.fn.expand('%')
--     else
--       data = vim.fn.expand('%:p')
--     end

-- 	data = omit_prefixes_general(data, options.omit_prefix_list)

--     if data == '' then
--       data = '[No Name]'
--     elseif vim.fn.winwidth(0) <= options.auto_shorten_winwidth or #data > options.auto_shorten_filenamelen then
--       data = vim.fn.pathshorten(data)
--     end

--     if options.file_status then
--       if vim.bo.modified then
--         data = data .. '[+]'
--       elseif vim.bo.modifiable == false then
--         data = data .. '[-]'
--       end
--     end
--     return data
-- end

-- local conf_lualine = {}
-- conf_lualine.smart_filename = function()
-- 	return smart_filename(filename_options)
-- end

-- return conf_lualine
-- -- return {smart_filename = filename, init = function(options) return filename(options) end}
