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

function NAT.mapLocal(port, address)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	print("Address: ", address)
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	if toLocal[port] then
		return nil, "Port is taken"
	end
	toLocal[port] = address
	return true
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
	return true
end

function NAT.unMapLocal(port)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	toLocal[port] = nil
	return true
end

function NAT.unMapGlobal(address)
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	toGlobal[address] = nil
	return true
end

function NAT.getLocal(port)
	port = checkPort(port)
	if not port then
		return nil, "Not a valid port"
	end
	if not toLocal[port] then
		return nil, "No such port"
	end
	return toLocal[port]
end

function NAT.getGlobal(address)
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	if not toGlobal[address] then
		return nil, "No such address"
	end
	return toGlobal[address]
end

return NAT