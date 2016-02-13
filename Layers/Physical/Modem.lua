--[[
	Modem wrapper by Creator
]]--

local Delta = ...

return function(side)
	if not peripheral.getType(side) == "modem" then
		return false, "No peripheral present on this side!"
	end
	local m = peripheral.wrap(side)
end