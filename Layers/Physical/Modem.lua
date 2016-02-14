--[[
	Modem wrapper by Creator
]]--

local Delta = ...
local SHA = Delta.lib.SHA
local toBase = Delta.lib.Utils.toBase
local CHANNEL = 127

local sides = {
	top 	= 0,
	bottom 	= 1,
	right 	= 2,
	left 	= 3,
	front 	= 4,
	back 	= 5,
}

return function(side,channel)
	if not peripheral.getType(side) == "modem" then
		return false, "No peripheral present on this side!"
	end
	local m = peripheral.wrap(side)
	local id = os.getComputerID()*6 + sides[side]
	m.MAC = toBase(id,16,6)
	local MAC = m.MAC
	print(MAC)

	--Code starts here
	m.open(CHANNEL)

	function m.send(destination,msg)
		m.transmit(m.channel,{
			sender = MAC,
			destination = destination
		})
	end
end