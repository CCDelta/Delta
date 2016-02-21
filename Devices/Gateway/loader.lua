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
local data = file.readAll()
file.close()

local datas = {}

for token in data:gmatch("[^\n]+") do
	print(token)
	datas[#datas+1] = token
end

local Delta = dofile("disk/Delta/init.lua", datas[1])
local Gateway = Delta.loadDevice("Gateway", datas[2], datas[3])
Gateway.run()
