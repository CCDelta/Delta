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
	local modems = {
		top = wrap("top"),
		bottom = wrap("bottom"),
		front = wrap("front"),
		back = wrap("back"),
		right = wrap("right"),
		left = wrap("left"),
	}

	for i,v in pairs(modems) do
		print(v.connect())
	end

	local ips = {

	}
	
	while true do
		event = {coroutine.yield("modem_message")}

	end
end

return Switch