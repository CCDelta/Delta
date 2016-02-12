--[[
	IP lib by Creator
]]--

local Delta = ...

local IP = {}

function IP.new(input)
	assert(type(input) == "string")
	local prefix, suffix = input:match("([^/]+)/([^/]+)")
	local one, two, three, four = prefix:match("([^%.]+)%.([^%.]+)%.([^%.]+)%.([^%.]+)")
	return {one, two, three, four, suffix}
end

Delta.IP = IP

return IP