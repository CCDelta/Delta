--[[
	DHCP Service
]]--

local Delta = ...

local function DHCP()
	local event = {}
	while true do
		event = {coroutine.yield("modem_message")}
		print(textutils.serialize(event))
	end
end

return DHCP