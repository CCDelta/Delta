local path, Delta = ...
local Thread = Delta.lib.Thread

local Gateway = {}
local Services = {}
local Processes = {}

m = Delta.modem("top")

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), m)

function Gateway.run()
	Thread.run(Services)
end

return Gateway