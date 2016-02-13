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

local function loadFolder()

end

return Delta