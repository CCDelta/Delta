--[[
	Thread library
]]--

local thread = {}

function thread.new(func, ...)
	--Private
	local process = coroutine.create(func)
	local filter = nil
	local first, ok, err

	ok, err = coroutine.resume(process, ...)
	if ok then
		filter = err
	else
		print(err)
		return false, err
	end

	--Public
	local self = {}

	self.resume = function(...)
		first = ...
		if filter == nil or first == filter then
			ok, err = coroutine.resume(process,...)
			if ok then
				filter = err
			else
				print(err)
				return err
			end
		end
	end

	return self
end

function thread.run(t, func)
	local event = {}
	while true do
		event = {os.pullEvent()}
		for i,v in pairs(t) do
			v.resume(unpack(event))
		end
		if func then
			func()
		end
	end
end

return thread