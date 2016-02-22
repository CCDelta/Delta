--[[
	DHCP Service
]]--

local Delta = ...
local base = "192.168."

local function DHCP(globalSide, ipSide, modems)
	local ips = {}
	local nextKey = 0
	local lessSig = 0
	local moreSig = 0

	local event = {}
	local newIP

	while true do
		event = {coroutine.yield("modem_message")}
		if event[2] ~= globalSide and event[3] == 65535 and event[4] == 0x0 then
			print("Answering request...")
			print("New IP: ", base..tostring(moreSig).."."..tostring(lessSig))
			newIP = base..tostring(moreSig).."."..tostring(lessSig)
			modems[event[2]].transmit(65534,0x1,{
				[1] = event[5],
				[2] = newIP
			})
			ipSide[newIP] = event[2]
			lessSig = lessSig + 1
			if lessSig == 256 then
				moreSig = moreSig + 1
				lessSig = 0
			end
		end
	end
end

return DHCP