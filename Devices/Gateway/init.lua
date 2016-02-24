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
	top = (globalSide ~= "top" and wrap("top")) or nil,
	bottom = (globalSide ~= "bottom" and wrap("bottom")) or nil,
	front = (globalSide ~= "front" and wrap("front")) or nil,
	back = (globalSide ~= "back" and wrap("back")) or nil,
	right = (globalSide ~= "right" and wrap("right")) or nil,
	left = (globalSide ~= "left" and wrap("left")) or nil,
}

for i,v in pairs(modems) do
	print(i)
	v.open(65535)
end

globalInterface = Delta.modem(globalSide)

local NAT = Delta.dofile(path.."lib/NAT.lua", Delta)

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), globalSide, ipSide, modems)
Services.Gateway = Thread.new(Delta.dofile(path.."Gateway.lua", Delta), globalInterface, globalSide, ipSide, modems, NAT)

function Gateway.run()
	Thread.run(Services)
end

return Gateway