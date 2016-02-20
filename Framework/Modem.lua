--[[
	Modem wrapper by Creator
]]--

local Delta = ...
local SHA = Delta.lib.SHA
local toBase = Delta.lib.Utils.toBase
local CHANNEL = 127

local function checkMAC(macaddress)
	if type(macaddress) ~= "string" then
		return false, "MAC address is no string."
	end
	if #macaddress ~= 6 then
		return false, "A MAC address has 6 hexadecimal digits."
	end
	if not tonumber("0x"..macaddress) then
		return false, "There are non hexadecimal digits."
	end
	return true
end

local sides = {
	top 	= 0,
	bottom 	= 1,
	right 	= 2,
	left 	= 3,
	front 	= 4,
	back 	= 5,
}

--[[CHANNELS
	65535 DHCP REQUESTS
	65534 DHCP RESPONSES
	64511 IP PACKETS
]]--


--[[DHCP
	0x0 DHCP_REQUEST
	0x1 DHCP_RESPONSE
	0x2 DHCP_DISCONNECT
	0x3 DHCP_DISCONNECT_CONFIRM
]]--




local function getIP(m, side, mac)
	m.open(65534)
	m.transmit(65535,0x0,mac)
	local event = {}
	repeat
		event = {os.pullEvent()}
	until event[1] == "modem_message" and event[2] == side and event[3] == 65534 and event[4] == 0x1 and type(event[5]) == "table" and event[5][1] == mac
	m.close(65534)
	return event[5][2]
end

local v = function(SIDE)
	--Peripheral
	if not peripheral.getType(SIDE) == "modem" then
		return false, "No peripheral present on this side!"
	end
	local m = peripheral.wrap(SIDE)

	--MAC
	local id = os.getComputerID()*6 + sides[SIDE]
	m.MAC = toBase(id,16,6)
	local MAC = m.MAC

	--IP
	local IP

	--Code starts here
	m.open(CHANNEL)


	function m.send(destination,msg)
		local res, err = checkMAC(destination)
		if not res then
			return false, err
		end
		m.transmit(CHANNEL,0,{
			sender = IPaddress,
			destination = destination,
			msg = msg
		})
		return true
	end

	function m.receive()
		local event = {coroutine.yield()}
		if event[1] ~= "modem_message" then
			return false, event
		end
		if event[2] ~= side then
			return false, event
		end
		if event[3] ~= CHANNEL then
			return false, event
		end
		local sender = event[5].sender
		local destination = event[5].destination
		local msg = event[5].msg
		if not (sender and destination and msg) then
			return false, event
		end
		return sender, destination, msg
	end

	function m.connect()
		IP = getIP(m, SIDE, MAC)
		m.IP = IP
	end

	return m
end

return v