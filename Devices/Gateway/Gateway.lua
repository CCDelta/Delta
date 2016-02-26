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
	local side, channel, protocol, IPpacket, destIP, sendIP, destPort, sendPort, message, TTL, dSide
	while true do
		event = {coroutine.yield("modem_message")}
		side, channel, protocol, IPpacket = event[2], event[3], event[4], event[5]
		if channel == 64511 and protocol == 0x0 and type(IPpacket) == "table" and type(IPpacket[6]) == "number" and IPpacket[6] >= 1 then
			destIP, sendIP, destPort, sendPort, message, TTL = IPpacket[1], IPpacket[2], IPpacket[3], IPpacket[4], IPpacket[5], IPpacket[6]
			if side == globalSide then

			else
				dSide = ipSide[destIP]
				if dSide then
					IPpacket[6] = IPpacket[6]-1
					if modems[dSide] then
						modems[dSide].transmit(64511, 0x0, IPpacket)
					else
						print("Side ", dSide, " has no modem.")
					end
				else
					print("IP ", destIP, " does not exist in the routing table.")
				end
			end
		end
	end
end

return Gateway --stuff