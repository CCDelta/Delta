--[[
	Switching Service
]]--

local Delta = ...
local base = "192.168."

local function Switch(m)

	m.open(65535)

	while true do
		event = {coroutine.yield("modem_message")}
		if event[3] ==  and event[4] == 0x0 then
			print("Answering request...")
			m.transmit(1023,0x1,{
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