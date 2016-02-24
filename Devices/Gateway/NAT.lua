--[[
	NAT service
]]--

local Delta = ...

local function DHCP(globalSide, modems, NAT)
	local event = {}
	local mapLocal = NAT.mapLocal -- to local
	local mapGlobal = NAT.mapGlobal -- to global
	local unMapLocal = NAT.unMapLocal
	local unMapGlobal = NAT.unMapGlobal

	while true do
		event = {coroutine.yield("modem_message")}
		print("NAT: ",event[1])
		if event[2] ~= globalSide and event[3] == 65535 then
			if event[4] == 0x2 then
				
			elseif event[4] == 0x3 then

			elseif event[4] == 0x4 then

			elseif event[4] == 0x5 then

			end
		end
	end
end

return DHCP