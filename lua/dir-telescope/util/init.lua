local Path = require("plenary.path")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local os_sep = Path.path.sep
local pickers = require("telescope.pickers")
local scan = require("plenary.scandir")
local time = require("dir-telescope.util.time")

local M = {}

M.get_dirs_slow = function(opts, fn)
	if opts.debug then
		time.time_start("get_dirs_slow")
	end

	local data = {}
	scan.scan_dir(vim.loop.cwd(), {
		hidden = opts.hidden,
		only_dirs = true,
		respect_gitignore = opts.respect_gitignore,
		on_insert = function(entry)
			table.insert(data, entry .. os_sep)
		end,
	})
	table.insert(data, 1, "." .. os_sep)

	pickers
		.new(opts, {
			prompt_title = "Select a Directory",
			finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
			previewer = conf.file_previewer(opts),
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
		print("get_dirs_slow took " .. time.time_end("get_dirs_slow") .. " seconds")
	end
end

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
	local respect_gitignore = opts.respect_gitignore

	if command == "fd" or command == "fdfind" then
		find_command[#find_command + 1] = "--strip-cwd-prefix"
		if hidden then
			find_command[#find_command + 1] = "--hidden"
		end
		if respect_gitignore then
			find_command[#find_command + 1] = "--no-ignore"
		end
	elseif command == "find" then
		if not hidden then
			table.insert(find_command, { "-not", "-path", "*/.*" })
			find_command = vim.tbl_flatten(find_command)
		end
		if respect_gitignore ~= nil then
			vim.notify(
				"The `no_ignore` key is not available for the `find` command in `find_files`.",
				vim.log.levels.WARN
			)
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
						previewer = conf.file_previewer(opts),
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
