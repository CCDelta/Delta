--[[
	IP lib by Creator
]]--

local Delta = ...

local IP = {}

function IP.new(input)
	prefix, suffix = input:match("([^/]+)/([^/]+)")
	print(prefix, " ", suffix)
end

Delta.IP = IP