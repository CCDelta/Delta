local path = ...

print(path)

local Delta = {}

dofile = function(path,...)
	local f = loadfile(path)
	setfenv(f,_G)
	return f(...)
end

Delta.IP = dofile(path.."/lib/IP.lua", Delta)
--Delta.BigNum = dofile(path.."/lib/BigNum.lua", Tunnel)
--Delta.DH = dofile(path.."/lib/DH.lua", Tunnel)
--Delta.SHA = dofile(path.."/lib/SHA.lua", Tunnel)

print(Tunnel.AES)

return Tunnel --wow