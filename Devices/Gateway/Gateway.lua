--[[
	Gateway Service
]]--

local Delta = ...

local function Gateway(globalInterface, globalSide, ipSide, modems, NAT)
	while true do
		event = {coroutine.yield("modem_message")}
		print(textutils.serialise(event))
	end
end

return Gateway --stuff