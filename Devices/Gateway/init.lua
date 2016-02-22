local path, Delta, localSide, globalSide = ...
local Thread = Delta.lib.Thread

local Gateway = {}
local Services = {}
local ipSide = {}

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

local modems = {
	top = globalSide ~= "top" and wrap("top"),
	bottom = globalSide ~= "bottom" and wrap("bottom"),
	front = globalSide ~= "front" and wrap("front"),
	back = globalSide ~= "back" and wrap("back"),
	right = globalSide ~= "right" and wrap("right"),
	left = globalSide ~= "left" and wrap("left"),
}

for i,v in pairs(modems) do
	v.open(65535)
end

globalInterface = Delta.modem(globalSide)

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), globalSide, ipSide, modems)
Services.Gateway = Thread.new(Delta.dofile(path.."Gateway.lua", Delta), globalInterface, globalSide, ipSide, modems)

function Gateway.run()
	Thread.run(Services)
end

return Gateway