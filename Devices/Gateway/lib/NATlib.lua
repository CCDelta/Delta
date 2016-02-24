--[[
	NAT sevice for the gateway.
]]--

local Delta = ...
local isValid = Delta.lib.Address.checkIfValid

local toGlobal = {}
local toLocal = {}

local function checkPort(p)
	p = tonumber(p)
	if not p then return end
	p = math.floor(p)
	if p < 0  or p > 65535 then
		return nil
	end
	return p
end

local NAT = {}

print("Loaded NAT")

NAT.toGlobal = toGlobal
NAT.toLocal = toLocal

function NAT.getLocal(port)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	return toLocal[port]
end

function NAT.mapLocal(port, address)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	if toLocal[port] then
		return nil, "Port is taken"
	end
	toLocal[port] = address
end

function NAT.mapGlobal(port, address)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	toGlobal[address] = port
end

function NAT.unMapLocal(port, address)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	if toLocal[port] then
		return nil, "Port is taken"
	end
	toLocal[port] = nil
end

function NAT.unMapGlobal(port, address)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	toGlobal[address] = nil
end

function NAT.getGlobal(address)
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	return toGlobal[address]
end

return NAT