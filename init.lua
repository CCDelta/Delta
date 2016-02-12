local path = ...

print(path)

local Delta = {}

dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

Delta.Utils, err = dofile(path.."/lib/Utils.lua", Delta)
Delta.IP, err = dofile(path.."/lib/IP.lua", Delta)

return Delta