--[[
	IP lib by Creator
]]--

local Delta = ...

local IP = {}
local reserved = {
	
}

function IP.new(input)
	assert(type(input) == "string")
	local prefix, suffix = input:match("([^/]+)/([^/]+)")
	local one, two, three, four = prefix:match("([^%.]+)%.([^%.]+)%.([^%.]+)%.([^%.]+)")
	return {
		[1] = one, 
		[2] = two, 
		[3] = three,
		[4] = four,
		suffix = suffix,
	}
end

return IP