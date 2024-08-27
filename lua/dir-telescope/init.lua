local find_in_dir = require("dir-telescope.features.find-in-dir").FileInDirectory
local grep_in_dir = require("dir-telescope.features.grep-in-dir").GrepInDirectory
local settings = require("dir-telescope.settings")

local M = {}

-- @param opts: table
-- @param opts.hidden: boolean
-- @param opts.no_ignore: boolean
-- @param opts.show_preview: boolean
-- @param opts.follow_symlinks: boolean
-- @param opts.live_grep: function
-- @param opts.debug : boolean
M.setup = function(opts)
	if opts then
		settings.set(opts)
	end

	M.create_commands(settings.current)
end

M.create_commands = function(opts)
	vim.api.nvim_create_user_command("GrepInDirectory", function()
		grep_in_dir(opts)
	end, {
		desc = "Live grep in selected directory",
	})

	vim.api.nvim_create_user_command("FileInDirectory", function()
		find_in_dir(opts)
	end, {
		desc = "Find files in selected directory",
	})
end

return M
