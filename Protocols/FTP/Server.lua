--[[
	Delta Networking FTP Server.
]]--

local path = ...

local dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

local Delta = dofile(path.."/init.lua", path)
local Thread = Delta.lib.Thread
local helper = {}
local processes = {}
local side

local permissions = {
	list = "admin",
	exists = "admin",
	isDir = "admin",
	isReadOnly = "admin",
	getSize = "admin",
	getFreeSpace = "admin",
	makeDir = "admin",
	move = "admin",
	copy = "admin",
	delete = "admin",
	combine = "admin",
	open = "admin",
	find = "admin",
	getDir = "admin",
}
local permValues = {
	["admin"] = true,
	["user"] = true,
	["false"] = true,
}

local function loadSettings()
	if not fs.exists(".ftp/permissions") then
		print("No permission file found, everything set to maximum security!")
		for i,v in pairs(permissions) do
			permissions[i] = "admin"
		end
	else
		local file = fs.open(".ftp/permissions", "r")
		local data = file.readAll()
		file.close()
		local index, value
		for token in data:gmatch("[^\n]+") do
			index, value = token:match("([^:]+):([^:]+)")
			permissions[index] = permValues[value] and value or "admin"
		end
	end
	if fs.exists(".ftp/side") then
		local file = fs.open(".ftp/side", "r")
		side = file.readAll()
		file.close()
		print(side)
	else
		for i,v in pairs(rs.getSides()) do
			if peripheral.getType(v) == "modem" then
				side = v
			end
		end
	end
end

loadSettings()

local connections = {}

local actions = {
	connect = function(a)
		
	end
}

local function main()
	coroutine.yield()
	local event = {}
	while true do

	end
end

local function clean()

end

processes.main = Thread.new(main)


