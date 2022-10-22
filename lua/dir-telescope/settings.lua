local M = {}

local DEFAULT_SETTINGS = {
	hidden = true,
	respect_gitignore = true,
}

M._DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = M._DEFAULT_SETTINGS

M.set = function(opts)
	M.current = vim.tbl_deep_extend("force", M.current, opts)
	vim.validate({
		hidden = { M.current.hidden, "boolean", true },
		respect_gitignore = { M.current.respect_gitignore, "boolean", true },
	})
end

return M
