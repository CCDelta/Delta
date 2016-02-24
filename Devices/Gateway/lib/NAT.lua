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
	return toLocal[port]
end

function NAT.getGlobal(address)
	if not isValid(address) then
		return nil, "Not a valid address"
	end
	return toGlobal[address]
end

return NAT