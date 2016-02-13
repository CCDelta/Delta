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
	[0] = IP.new("0.0.0.0/8"), 			--0x0		Current network (only valid as source address) 	RFC 6890
	[1] = IP.new("10.0.0.0/8"), 		--0x1		Private network 	RFC 1918
	[2] = IP.new("100.64.0.0/10"), 		--0x2		Shared Address Space 	RFC 6598
	[3] = IP.new("127.0.0.0/8"), 		--0x3		Loopback 	RFC 6890
	[4] = IP.new("169.254.0.0/16"), 	--0x4		Link-local 	RFC 3927
	[5] = IP.new("172.16.0.0/12"), 		--0x5		Private network 	RFC 1918
	[6] = IP.new("192.0.0.0/24"), 		--0x6		IETF Protocol Assignments 	RFC 6890
	[7] = IP.new("192.0.2.0/24"), 		--0x7		TEST-NET-1, documentation and examples 	RFC 5737
	[8] = IP.new("192.88.99.0/24"), 	--0x8		IPv6 to IPv4 relay 	RFC 3068
	[9] = IP.new("192.168.0.0/16"), 	--0x9		Private network 	RFC 1918
	[10] = IP.new("198.18.0.0/15"), 	--0xa		Network benchmark tests 	RFC 2544
	[11] = IP.new("198.51.100.0/24"), 	--0xb		TEST-NET-2, documentation and examples 	RFC 5737
	[12] = IP.new("203.0.113.0/24"), 	--0xc		TEST-NET-3, documentation and examples 	RFC 5737
	[13] = IP.new("224.0.0.0/4"), 		--0xd		IP multicast (former Class D network) 	RFC 5771
	[14] = IP.new("240.0.0.0/4"), 		--0xe		Reserved (former Class E network) 	RFC 1700
	[15] = IP.new("255.255.255.255/32"), 	--0xf		Broadcast	RFC 919
}

function IP.isReserved(address)
	for i=0,15 do
		print(IP.reserved[i].network)
		print(IP.reserved[i].length)
	end
end

return IP