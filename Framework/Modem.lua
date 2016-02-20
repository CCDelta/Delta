--[[
	Modem wrapper by Creator
]]--

local Delta = ...
local SHA = Delta.lib.SHA
local toBase = Delta.lib.Utils.toBase

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


local function getIP(m, side, mac, timeout)
	m.open(65534)
	m.transmit(65535,0x0,mac)
	local event = {}
	local timer = os.startTimer(timeout or 0.5)
	repeat
		event = {os.pullEvent()}
	until (event[1] == "modem_message" and event[2] == side and event[3] == 65534 and event[4] == 0x1 and type(event[5]) == "table" and event[5][1] == mac) or (event[1] == "timer" and event[2] == timer)
	os.cancelTimer(timer)
	m.close(65534)
	if event[1] == "timer" then
		return false
	elseif event[1] == "modem_message" then
		return event[5][2]
	end
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


	function m.send(destination_ip,destination_port,this_port,msg)
		m.transmit(64511,0,{
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

	function m.connect(timeout)
		IP = getIP(m, SIDE, MAC, timeout)
		m.IP = IP
		if IP then return true else return false end
	end

	function m.setIP(l)
		IP = l
		m.IP = l
		return true
	end

	return m
end

return v