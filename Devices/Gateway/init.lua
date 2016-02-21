local path, Delta, localSide, globalSide = ...
local Thread = Delta.lib.Thread

local Gateway = {}
local Services = {}
local Processes = {}

localInterface = Delta.modem(localSide)
globalInterface = Delta.modem(globalSide)

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), localInterface)
Services.Gateway = Thread.new(Delta.dofile(path.."Gateway.lua", Delta), localInterface, globalInterface)

function Gateway.run()
	Thread.run(Services)
end

return Gateway