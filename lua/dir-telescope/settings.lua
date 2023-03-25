local M = {}

local DEFAULT_SETTINGS = {
	hidden = true,
	debug = false,
	respect_gitignore = true,
	default_dir = "cwd",
}

M._DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M._DEFAULT_SETTINGS

M.set = function(opts)
	M.current = vim.tbl_deep_extend("force", M.current, opts)
	vim.validate({
		hidden = { M.current.hidden, "boolean", true },
		debug = { M.current.debug, "boolean", true },
		respect_gitignore = { M.current.respect_gitignore, "boolean", true },
		default_dir = { M.current.default_dir, "string", "cwd" },
	})
end

return M
