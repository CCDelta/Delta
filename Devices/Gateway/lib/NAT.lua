--[[
	NAT sevice for the gateway.
]]--

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

NAT.toGlobal = toGlobal
NAT.toLocal = toLocal

function NAT.getLocal(port)
	return toLocal[checkPort(port)]
end

return NAT