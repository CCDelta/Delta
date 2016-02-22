--[[
	DHCP Service
]]--

local Delta = ...
local base = "192.168."

local function DHCP(globalSide, ipSide)
	local ips = {}
	local nextKey = 0
	local lessSig = 0
	local moreSig = 0

	local modems = {
		top = globalSide ~= "top" and wrap("top"),
		bottom = globalSide ~= "bottom" and wrap("bottom"),
		front = globalSide ~= "front" and wrap("front"),
		back = globalSide ~= "back" and wrap("back"),
		right = globalSide ~= "right" and wrap("right"),
		left = globalSide ~= "left" and wrap("left"),
	}

	for i,v in pairs(modems) do
		v.open(65535)
	end

	local event = {}

	while true do
		event = {coroutine.yield("modem_message")}
		if event[3] == 65535 and event[4] == 0x0 then
			print("Answering request...")
			print("New IP: ", base..tostring(moreSig).."."..tostring(lessSig))
			m.transmit(65534,0x1,{
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