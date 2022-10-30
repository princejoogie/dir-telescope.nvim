local builtin = require("telescope.builtin")
local get_dirs = require("dir-telescope.util").get_dirs_slow

local M = {}

M.GrepInDirectory = function(opts)
  get_dirs(opts, builtin.live_grep)
end

return M
