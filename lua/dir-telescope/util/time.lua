local M = {}

local table = {}

M.time_start = function(name)
	table[name] = os.clock()
end

M.time_end = function(name)
	if table[name] then
		local time = os.clock() - table[name]
		table[name] = nil
		return time
	else
		return nil
	end
end

return M
