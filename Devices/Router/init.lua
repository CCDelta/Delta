local path, Delta, m = ...
local Thread = Delta.lib.Thread

local Router = {}
local Services = {}
local Processes = {}

Services.DHCP = Thread.new(dofile(path.."DHCP.lua"), m)

function Router.run()
	Thread.run(Services)
end

return Router