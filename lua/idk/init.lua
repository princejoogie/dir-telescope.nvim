local M = {}

M.setup = function ()
  print("Hello world!")
  require("idk.features.find-in-dir")
  require("idk.features.grep-in-dir")
end

return M
