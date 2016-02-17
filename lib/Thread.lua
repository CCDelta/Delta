--[[
	Thread library
]]--

local function thread(func, ...)
	--Private
	local process = coroutine.create(func)
	local filter = nil
	local first

	--Public
	local self = {}

	self.resume = function(...)
		first = ...
		if filter == nil or first == filter then
			coroutine.resume(process,...)
		end
	end

end