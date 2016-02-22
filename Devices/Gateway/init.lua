local path, Delta, localSide, globalSide = ...
local Thread = Delta.lib.Thread

local Gateway = {}
local Services = {}
local ipSide = {}

globalInterface = Delta.modem(globalSide)

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), globalSide, ipSide)
Services.Gateway = Thread.new(Delta.dofile(path.."Gateway.lua", Delta), globalInterface, globalSide, ipSide)

function Gateway.run()
	Thread.run(Services)
end

return Gateway