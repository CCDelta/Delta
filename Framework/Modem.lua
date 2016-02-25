--[[
	Modem wrapper by Creator
]]--

local Delta = ...
local SHA = Delta.lib.SHA
local toBase = Delta.lib.Utils.toBase
local isValid = Delta.lib.Address.checkIfValid

local function checkPort(p)
	p = tonumber(p)
	if not p then return end
	p = math.floor(p)
	if p < 0  or p > 65535 then
		return nil
	end
	return p
end

local function checkMAC(macaddress)
	if type(macaddress) ~= "string" then
		return false, "MAC address is no string."
	end
	if #macaddress ~= 6 then
		return false, "A MAC address has 6 hexadecimal digits."
	end
	if not tonumber("0x"..macaddress) then
		return false, "There are non hexadecimal digits."
	end
	return true
end

local sides = {
	top 	= 0,
	bottom 	= 1,
	right 	= 2,
	left 	= 3,
	front 	= 4,
	back 	= 5,
}


local function getIP(m, side, mac, timeout)
	m.open(65534)
	m.transmit(65535,0x0,mac)
	local event = {}
	local timer = os.startTimer(timeout or 1)
	repeat
		event = {os.pullEvent()}
	until (event[1] == "modem_message" and event[2] == side and event[3] == 65534 and event[4] == 0x0 and type(event[5]) == "table" and event[5][1] == mac) or (event[1] == "timer" and event[2] == timer)
	os.cancelTimer(timer)
	m.close(65534)
	if event[1] == "timer" then
		return false, "Timer"
	elseif event[1] == "modem_message" then
		return event[5][2]
	end
end

local v = function(SIDE)
	if not SIDE then
		error("SIDE", 2)
	end

	--Peripheral
	if not peripheral.getType(SIDE) == "modem" then
		return false, "No peripheral present on this side!"
	end
	local m = peripheral.wrap(SIDE)

	--MAC
	local id = os.getComputerID()*6 + sides[SIDE]
	m.MAC = toBase(id,16,6)
	local MAC = m.MAC

	--IP
	local IP

	--Code starts here
	m.open(64511)

	function m.send(destination_ip,destination_port,this_port,msg)
		m.transmit(64511,0,{
			[1] = destination_ip,
			[2] = IP,
			[3] = destination_port,
			[4] = this_port,
			[5] = msg,
			[6] = 32,
		})
		return true
	end

	function m.receive()
		--[[{
			[1] = Destination IP
			[2] = Sender IP
			[3] = Destination Port
			[4] = Sender Port
			[5] = Message
			[6] = TTL
		}]]--

		local event = {coroutine.yield()}
		if event[1] ~= "modem_message" then
			print(event[1])
			return false, event
		end
		if event[2] ~= SIDE then
			print(event[2])
			return false, event
		end
		if event[3] ~= 64511 then
			print(event[3])
			return false, event
		end
		if event[5][1] ~= IP then
			print(event[5][1])
			print(IP)
			return false, event
		end
		return event[5]
	end

	function m.connect(timeout)
		IP = getIP(m, SIDE, MAC, timeout)
		m.IP = IP
		if IP then return true else return false end
	end

	function m.setIP(l)
		IP = l
		m.IP = l
		return true
	end

	function m.mapLocal(port, address)
		port = checkPort(port)
		if not port then
			return nil, "Not a valid port"
		end
		if not isValid(address) then
			return nil, "Not a valid address"
		end
		m.transmit(65535,0x2,{
			[1] = port,
			[2] = address
		})
		return true
	end
	
	function m.mapGlobal(port, address)
		port = checkPort(port)
		if not port then
			return nil, "Not a valid port"
		end
		if not isValid(address) then
			return nil, "Not a valid address"
		end
		m.transmit(65535,0x3,{
			[1] = port,
			[2] = address
		})
		return true
	end
	
	function m.unMapLocal(port)
		port = checkPort(port)
		if not port then
			return nil, "Not a valid port"
		end
		if not isValid(address) then
			return nil, "Not a valid address"
		end
		m.transmit(65535,0x4,{
			[1] = port
		})
		return true
	end
	
	function m.unMapGlobal(address)
		port = checkPort(port)
		if not port then
			return nil, "Not a valid port"
		end
		if not isValid(address) then
			return nil, "Not a valid address"
		end
		m.transmit(65535,0x5,{
			[1] = address
		})
		return true
	end

	return m
end

return v