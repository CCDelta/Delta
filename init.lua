local path = ...

print(path)

local Delta = {}

dofile = function(path,...)
	local f = loadfile(path)
	setfenv(f,_G)
	return f(...)
end

Delta.Utils = dofile(path.."/lib/Utils.lua", Delta)
Delta.IP = dofile(path.."/lib/IP.lua", Delta)

return Delta --wow