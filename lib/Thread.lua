--[[
	Thread library
]]--

local thread = {}

function thread.new(func, ...)
	--Private
	local process = coroutine.create(func)
	local filter = nil
	local first, ok, err

	print("...: ", ...)

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
			print("Resuming more...")
			ok, err = coroutine.resume(process,...)
			if ok then
				filter = err
			else
				return err
			end
		end
	end

	return self
end

function thread.run(t)
	local event = {}
	while true do
		event = {os.pullEvent()}
		print(event[1])
		for i,v in pairs(t) do
			print(i)
			print(type(v))
			v.resume(unpack(event))
		end
	end
end

return thread