local find_in_dir = require("dir-telescope.features.find-in-dir").FileInDirectory
local grep_in_dir = require("dir-telescope.features.grep-in-dir").GrepInDirectory
local settings = require("dir-telescope.settings")

return require("telescope").register_extension({
	exports = {
		live_grep = function()
			grep_in_dir(settings.current)
		end,
		find_files = function()
			find_in_dir(settings.current)
		end,
	},
})
