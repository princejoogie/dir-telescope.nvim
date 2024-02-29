local get_dirs = require("dir-telescope.util").get_dirs

local M = {}

M.GrepInDirectory = function(opts)
	get_dirs(opts, opts.live_grep)
end

return M
