local path, Delta = ...
local Thread = Delta.lib.Thread

local Router = {}
local Services = {}
local Processes = {}

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), m)
Services.test = Thread.new((function(j) print(j) os.pullEvent() end),"lelssss")

function Router.run()
	Thread.run(Services)
end

return Router