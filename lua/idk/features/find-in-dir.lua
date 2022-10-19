local builtin = require("telescope.builtin")
local get_dirs = require("idk.util").get_dirs

local M = {}

M.FileInFolder = function(opts)
	local dirs = get_dirs(opts)
	builtin.find_files({ search_dirs = dirs })
end

vim.api.nvim_create_user_command("FileInFolder", function()
	M.FileInFolder({
		hidden = true,
		respect_gitignore = true,
	})
end, {
	desc = "Find files in selected folder",
})

return M
