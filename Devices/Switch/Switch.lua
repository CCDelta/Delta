--[[
	Switching Service
]]--

local Delta = ...

local function wrap(side)
	if peripheral.isPresent(side) then
		if peripheral.getType(side) == "modem" then
			if peripheral.call(side,"isWireless") == false then
				return Delta.modem(side)
			end
		end
	end
	return nil
end

local function Switch()
	local MainSide
	local MainIP
	local modems = {
		top = wrap("top"),
		bottom = wrap("bottom"),
		front = wrap("front"),
		back = wrap("back"),
		right = wrap("right"),
		left = wrap("left"),
	}

	for i,v in pairs(modems) do
		if v.connect() then
			MainSide = i
			MainIP = v.IP
		end
	end

	for i,v in pairs(modems) do
		v.setIP(MainIP)
	end

	print(MainSide)

	local ips = {

	}
	
	while true do
		event = {coroutine.yield("modem_message")}

	end
end

return Switch