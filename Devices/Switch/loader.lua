dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

local file = fs.open(".path","r")
local path = file.readAll()
file.close()

local Delta = dofile("disk/Delta/init.lua", path)
local Switch = Delta.loadDevice("Switch")
Switch.run()
