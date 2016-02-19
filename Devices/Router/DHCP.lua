--[[
	DHCP Service
]]--

local Delta = ...
print(type(Delta), " <== Delta")

local function DHCP(m)
	local event = {}
	print("Starting DHCP...")
	print("m: ", m)
	m.open(1024)
	print(m.isOpen(1024))
	print("Running")

	while true do
		event = {coroutine.yield("modem_message")}
		print("yay")
		print(textutils.serialize(event))
	end
end

return DHCP