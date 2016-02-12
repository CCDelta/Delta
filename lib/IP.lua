--[[
	IP lib by Creator
]]--

local Delta = ...

local IP = {}
local reserved = {
	
}

function IP.new(input)
	assert(type(input) == "string")
	local address, length = input:match("([^/]+)/([^/]+)")
	local one, two, three, four = address:match("([^%.]+)%.([^%.]+)%.([^%.]+)%.([^%.]+)")
	local binary = Delta.Utils.toBase(tonumber(one),2,8)..Delta.Utils.toBase(tonumber(two),2,8)..Delta.Utils.toBase(tonumber(three),2,8)..Delta.Utils.toBase(tonumber(four),2,8)
	local network, host = binary:sub(1,length), binary:sub(length+1,-1)
	return {
		[1] = one, 
		[2] = two, 
		[3] = three,
		[4] = four,
		length = length,
		binary = binary,
		network = network,
		host = host,
	}
end

return IP