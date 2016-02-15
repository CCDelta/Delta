--[[
	Modem wrapper by Creator
]]--

local Delta = ...
local SHA = Delta.lib.SHA
local toBase = Delta.lib.Utils.toBase
local CHANNEL = 127

--[[local function checkMAC(macaddress)
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
}]]--

return function(side,channel)
	if not peripheral.getType(side) == "modem" then
		return false, "No peripheral present on this side!"
	end
	local m = peripheral.wrap(side)
	local id = os.getComputerID()*6 + sides[side]
	m.MAC = toBase(id,16,6)
	local MAC = m.MAC
	local SIDE = side

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
		if event[2] ~= SIDE then
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

	return m
end