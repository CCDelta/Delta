--[[
	DHCP Service
]]--

local Delta = ...

local function DHCP(modem)
	local event = {}
	modem.open(65535)

	while true do
		event = {coroutine.yield("modem_message")}
		print("yay")
		print(textutils.serialize(event))
	end
end

return DHCP