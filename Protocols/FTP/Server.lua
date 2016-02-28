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
local DH = Delta.lib.DH
local helper = {}
local processes = {}
local side, port, connectionPort

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
		print("Side")
		print(side)
	else
		print("Side")
		for i,v in pairs(rs.getSides()) do
			if peripheral.getType(v) == "modem" then
				side = v
				print(side)
			end
		end
		if side == nil then
			error("No modem found!")
		end
	end
	if fs.exists(".ftp/ports") then
		local file = fs.open(".ftp/side", "r")
		local portsData = file.readAll()
		file.close()
		port, connectionPort = portsData:match("([^\n]+)[\n]([^\n]+)")
		port = tonumber(port) or 20
		connectionPort = tonumber(connectionPort) or 21
	else

	end
end

loadSettings()

local modem = Delta.modem(side)

local function setUpConnection(...)
	local id, IP, dest_port = ...
	DH(modem, IP, dest_port, connectionPort)
end

local connections = {}

local actions = {
	connect = function(a)
		
	end
}

--[[IP_PACKET
	{
		[1] = Destination IP
		[2] = Sender IP
		[3] = Destination Port
		[4] = Sender Port
		[5] = Message
		[6] = TTL
	}]]

local function main()
	local event = {}
	local action, user, pass, arguments
	while true do
		event, dummy = modem.receive(true)
		if event and event[3] == port and type(event[5]) == "table" then
			if actions[action] then

			else

			end
		end
	end
end

local function clean()
	for i,v in pairs(helper) do
		if v == "done" and type(i) == "number" then
			processes[i] = nil
		end
	end
end

processes.main = Thread.new(main)

Thread.run(processes, clean)


