local find_in_dir = require("dir-telescope.features.find-in-dir").FileInDirectory
local grep_in_dir = require("dir-telescope.features.grep-in-dir").GrepInDirectory

local M = {}

-- @param opts: table
-- @param opts.title: string
-- @param opts.hidden: boolean
-- @param opts.respect_gitignore: boolean
M.setup = function(opts)
	opts = opts or {}
	opts.hidden = opts.hidden or true
	opts.respect_gitignore = opts.respect_gitignore or true
	opts.title = opts.title or "Select a directory"

	M.create_commands(opts)
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
