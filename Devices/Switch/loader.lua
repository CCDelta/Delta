dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

if not fs.exists("path") then
	print("path file does not exist...")
	return
end

local file = fs.open("path","r")
local path = file.readAll()
file.close()

local Delta = dofile("disk/Delta/init.lua", path)
local Switch = Delta.loadDevice("Switch")
Switch.run()
