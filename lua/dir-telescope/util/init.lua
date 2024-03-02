local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local time = require("dir-telescope.util.time")

local flatten = vim.tbl_flatten

local M = {}

M.get_dirs = function(opts, fn)
	if opts.debug then
		time.time_start("get_dirs")
	end

	local find_command = (function()
		if opts.find_command then
			if type(opts.find_command) == "function" then
				return opts.find_command(opts)
			end
			return opts.find_command
		elseif 1 == vim.fn.executable("fd") then
			return { "fd", "--type", "d", "--color", "never" }
		elseif 1 == vim.fn.executable("fdfind") then
			return { "fdfind", "--type", "d", "--color", "never" }
		elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
			return { "find", ".", "-type", "d" }
		end
	end)()

	if not find_command then
		vim.notify("dir-telescope", {
			msg = "You need to install either find, fd",
			level = vim.log.levels.ERROR,
		})
		return
	end

	local command = find_command[1]
	local hidden = opts.hidden
	local no_ignore = opts.no_ignore
	local follow_symlinks = opts.follow_symlinks

	if opts.respect_gitignore then
		vim.notify("dir-telescope: respect_gitignore is deprecated, use no_ignore instead", vim.log.levels.ERROR)
	end

	if command == "fd" or command == "fdfind" or command == "rg" then
		if hidden then
			find_command[#find_command + 1] = "--hidden"
		end
		if no_ignore then
			find_command[#find_command + 1] = "--no-ignore"
		end
		if follow_symlinks then
			find_command[#find_command + 1] = "--follow"
		end
	elseif command == "find" then
		if not hidden then
			table.insert(find_command, { "-not", "-path", "*/.*" })
			find_command = flatten(find_command)
		end
		if no_ignore ~= nil then
			vim.notify(
				"The `no_ignore` key is not available for the `find` command in `get_dirs`.",
				vim.log.levels.WARN
			)
		end
		if follow_symlinks then
			find_command[#find_command + 1] = "-follow"
		end
	else
		vim.notify("dir-telescope: You need to install either find or fd/fdfind", vim.log.levels.ERROR)
	end

	local getPreviewer = function()
		if opts.show_preview then
			return conf.file_previewer(opts)
		else
			return nil
		end
	end

	vim.fn.jobstart(find_command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				pickers
					.new(opts, {
						prompt_title = "Select a Directory",
						finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
						previewer = getPreviewer(),
						sorter = conf.file_sorter(opts),
						attach_mappings = function(prompt_bufnr)
							action_set.select:replace(function()
								local current_picker = action_state.get_current_picker(prompt_bufnr)
								local dirs = {}
								local selections = current_picker:get_multi_selection()
								if vim.tbl_isempty(selections) then
									table.insert(dirs, action_state.get_selected_entry().value)
								else
									for _, selection in ipairs(selections) do
										table.insert(dirs, selection.value)
									end
								end
								actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
								fn({ search_dirs = dirs })
							end)
							return true
						end,
					})
					:find()

				if opts.debug then
					print("get_dirs took " .. time.time_end("get_dirs") .. " seconds")
				end
			else
				vim.notify("No directories found", vim.log.levels.ERROR)
			end
		end,
	})
end

return M
