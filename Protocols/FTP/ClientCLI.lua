--[[
	Client CLI
]]--

dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

local Delta = dofile(path.."/init.lua", path)
local FTP = dofile(path.."/Protocols/FTP/Client.lua", Delta)

print("CLI FTP Client by Creator")

term.write("Input IP: ")
local IP = read()

term.write("Input dest port: ")
local dest_port = tonumber(read())

term.write("Input send port: ")
local send_port = tonumber(read())

local connection = FTP(IP, dest_port, send_port)