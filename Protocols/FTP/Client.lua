--[[
	Delta Network FTP Client
]]--

local Delta = ...
local AES = Delta.lib.AES
local SHA = Delta.lib.SHA256
local DH = Delta.lib.DH

local FTP = function(modem, ip, dest_port, send_port)
	assert(type(modem) == "table", "Please pass a modem!")
	assert(type(ip) == "string", "Please pass an IP!")
	assert(type(dest_port) == "number", "Please pass a dest_port!")
	assert(type(send_port) == "number", "Please pass a send_port!")
	local key, enc_pass, user

	local self = {}

	self.connect = function()
		key = SHA(tostring(DH(modem, ip, dest_port, send_port)))
		enc_pass = AES.encryptBytes(key, pass)
	end

	self.list = function(path)

	end

	self.exists = function(path)

	end

	self.isDir = function(path)

	end

	self.isReadOnly = function(path)

	end

	self.getSize = function(path)

	end

	self.getFreeSpace = function(path)

	end

	self.makeDir = function(path)

	end

	self.move = function(path)

	end

	self.copy = function(path)

	end

	self.delete = function(path)

	end

	self.combine = function(path)

	end

	self.open = function(path)

	end

	self.find = function(path)

	end

	self.getDir = function(path)

	end
	
	return self
end

return FTP