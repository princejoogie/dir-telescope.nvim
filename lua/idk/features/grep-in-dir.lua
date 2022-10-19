local builtin = require("telescope.builtin")
local get_dirs = require("idk.util").get_dirs

local M = {}

M.GrepInFolder = function(opts)
  local dirs = get_dirs(opts)
	builtin.live_grep({ search_dirs = dirs })
end

vim.api.nvim_create_user_command("GrepInFolder", function()
	M.GrepInFolder({
		hidden = true,
		respect_gitignore = true,
	})
end, {
	desc = "Live grep in selected folder",
})

return M
