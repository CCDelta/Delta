--[[
	Gateway Service
]]--

local Delta = ...

local function DHCP(m)
	while true do
		event = {coroutine.yield("modem_message")}

	end
end

return DHCP