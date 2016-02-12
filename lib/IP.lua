--[[
	IP lib by Creator
]]--

local Delta = ...

local IP = {}

function IP.new(input)
	assert(type(input) == "string")
	local prefix, suffix = input:match("([^/]+)/([^/]+)")
	local prefixes = prefix
end

Delta.IP = IP

return IP