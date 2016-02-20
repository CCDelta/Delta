local path, Delta = ...
local Thread = Delta.lib.Thread

local Switch = {}
local Services = {}
local Processes = {}

Services.DHCP = Thread.new(Delta.dofile(path.."Switch.lua", Delta), m)

function Switch.run()
	Thread.run(Services)
end

return Switch