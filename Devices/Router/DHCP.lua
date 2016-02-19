--[[
	DHCP Service
]]--

local Delta = ...

local function DHCP(m)
	local event = {}
	print("Starting DHCP...")
	m.open(1024)
	print(m.isOpen(1024))

	while true do
		event = {coroutine.yield("modem_message")}
		print(textutils.serialize(event))
	end
end

return DHCP