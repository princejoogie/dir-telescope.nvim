local builtin = require("telescope.builtin")
local get_dirs = require("dir-telescope.util").get_dirs

local M = {}

M.FileInDirectory = function(opts)
	get_dirs(opts, builtin.find_files)
end

return M
