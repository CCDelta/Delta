--[[
	DHCP Service
]]--

local Delta = ...
local base = "192.168."

local function DHCP(m)
	local ips = {}
	local nextKey = 0
	local lessSig = 0
	local moreSig = 0

	local event = {}
	m.open(1024)

	while true do
		event = {coroutine.yield("modem_message")}
		if event[3] == 1024 and event[4] == 0x0 then
			m.transmit(1024,0x0,{
				[1] = event[5],
				[2] = base..tostring(moreSig).."."..tostring(lessSig)
			})
			lessSig = lessSig + 1
			if lessSig == 256 then
				moreSig = moreSig + 1
				lessSig = 0
			end
		end
	end
end

return DHCP