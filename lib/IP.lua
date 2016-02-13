--[[
	IP lib by Creator
]]--

local Delta = ...

local IP = {}

function IP.new(input)
	assert(type(input) == "string")
	local address, length = input:match("([^/]+)/([^/]+)")
	address = input:find("/") and address or input
	local one, two, three, four = address:match("([^%.]+)%.([^%.]+)%.([^%.]+)%.([^%.]+)")
	local binary = Delta.Utils.toBase(tonumber(one),2,8)..Delta.Utils.toBase(tonumber(two),2,8)..Delta.Utils.toBase(tonumber(three),2,8)..Delta.Utils.toBase(tonumber(four),2,8)
	local network, host
	if length then
		network, host = binary:sub(1,length), binary:sub(length+1,-1)
	end
	return {
		[1] = one, 
		[2] = two, 
		[3] = three,
		[4] = four,
		length = length,
		binary = binary,
		network = network,
		host = host,
		original = input,
	}
end

IP.reserved = {
	IP.new("0.0.0.0/8"), 		--Current network (only valid as source address) 	RFC 6890
	IP.new("10.0.0.0/8"), 		--Private network 	RFC 1918
	IP.new("100.64.0.0/10"), 	--Shared Address Space 	RFC 6598
	IP.new("127.0.0.0/8"), 	--Loopback 	RFC 6890
	IP.new("169.254.0.0/16"), 	--Link-local 	RFC 3927
	IP.new("172.16.0.0/12"), 	--Private network 	RFC 1918
	IP.new("192.0.0.0/24"), 	--IETF Protocol Assignments 	RFC 6890
	IP.new("192.0.2.0/24"), 	--TEST-NET-1, documentation and examples 	RFC 5737
	IP.new("192.88.99.0/24"), 	--IPv6 to IPv4 relay 	RFC 3068
	IP.new("192.168.0.0/16"), 	--Private network 	RFC 1918
	IP.new("198.18.0.0/15"), 	--Network benchmark tests 	RFC 2544
	IP.new("198.51.100.0/24"), --TEST-NET-2, documentation and examples 	RFC 5737
	IP.new("203.0.113.0/24"), 	--TEST-NET-3, documentation and examples 	RFC 5737
	IP.new("224.0.0.0/4"), 	--IP multicast (former Class D network) 	RFC 5771
	IP.new("240.0.0.0/4"), 	--Reserved (former Class E network) 	RFC 1700
	IP.new("255.255.255.255"), --Broadcast	RFC 919
}

IP.ids = {
	
}

function IP.isReserved(address)
	if 
end

return IP