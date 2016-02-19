local path, Delta = ...
local Thread = Delta.lib.Thread

local Router = {}
local Services = {}
local Processes = {}

m = Delta.modem("top")

Services.DHCP = Thread.new(Delta.dofile(path.."DHCP.lua", Delta), m)
Services.test = Thread.new((function(j) while true do print(j) os.pullEvent() end end),"A side process...")

function Router.run()
	Thread.run(Services)
end

return Router