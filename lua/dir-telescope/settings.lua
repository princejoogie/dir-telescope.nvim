local builtin = require("telescope.builtin")
local M = {}

local DEFAULT_SETTINGS = {
	hidden = true,
	debug = false,
	no_ignore = false,
	show_preview = true,
	follow_symlinks = false,
	live_grep = builtin.live_grep,
}

M._DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M._DEFAULT_SETTINGS

M.set = function(opts)
	M.current = vim.tbl_deep_extend("force", M.current, opts)
	vim.validate("hidden", M.current.hidden, "boolean")
	vim.validate("debug", M.current.debug, "boolean")
	vim.validate("no_ignore", M.current.no_ignore, "boolean")
	vim.validate("show_preview", M.current.show_preview, "boolean")
	vim.validate("follow_symlinks", M.current.follow_symlinks, "boolean")
end

return M
