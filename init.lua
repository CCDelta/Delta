local path = ...

local Tunnel = {}

dofile = function(path,...)
	local f = loadfile(path)
	setfenv(f,_G)
	return f(...)
end

Tunnel.AES = dofile(path.."/lib/AES.lua", Tunnel)
Tunnel.BigNum = dofile(path.."/lib/BigNum.lua", Tunnel)
Tunnel.DH = dofile(path.."/lib/DH.lua", Tunnel)
Tunnel.SHA = dofile(path.."/lib/SHA.lua", Tunnel)

print(Tunnel.AES)

return Tunnel --wow