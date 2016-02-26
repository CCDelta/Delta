--[[
	Gateway Service

	IP_PACKET
	{
		[1] = Destination IP
		[2] = Sender IP
		[3] = Destination Port
		[4] = Sender Port
		[5] = Message
		[6] = TTL
	}
]]--

local Delta = ...

local function Gateway(globalInterface, globalSide, ipSide, modems, NAT)
	local side, channel, protocol, IPpacket, destIP, sendIP, destPort, sendPort, message, TTL
	while true do
		event = {coroutine.yield("modem_message")}
		side, channel, protocol, IPpacket = event[2], event[3], event[4], event[5]
		if channel == 64511 and protocol == 0x0 and type(IPpacket) == "table" then
			
		end
	end
end

return Gateway --stuff