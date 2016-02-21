--[[
	Gateway Service
]]--

local Delta = ...

local function DHCP(localInterface, globalInterface)
	while true do
		event = {coroutine.yield("modem_message")}
		print(textutils.serialise(event))
	end
end

return DHCP