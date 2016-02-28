local Delta = ...
local BigNum = Delta.lib.BigNum
local doDebug = false

local round = function(n)
	if not n then print(n) error("",2) end
	return math.floor((n or 0)+.5)
end

local function checkDist(argument,event)
	if not argument then
		return true
	end
	return argument == event[6]
end

local function generateEvent(...)
	local name, side, channel, port, message, distance = ...
	return {
		[1] = name,
		[2] = side,
		[3] = channel,
		[4] = port,
		[5] = message,
		[6] = distance,
	}
end

local function debugPrint(...)
	if doDebug then
		print(...)
	end
end

function connect(modem, IP, dest_port, sender_port)
	print(BigNum)
	local prime = BigNum.new("625210769")
	local base = BigNum.new("11")
	local secret = BigNum.new(math.random(1,800))
	local event = {}
	local order
	local _, mySecret = BigNum.mt.div((base^secret),prime)
	local hisSecret
	
	debugPrint("Loaded everything...")

	modem.send(IP, dest_port, sender_port,"ping")

	debugPrint("Sent ping message...")

	--[[{
		[1] = Destination IP
		[2] = Sender IP
		[3] = Destination Port
		[4] = Sender Port
		[5] = Message
		[6] = TTL
	}]]--
	
	while true do
		event = modem.receive("modem_message")
		debugPrint("One more iteration...")
		--event, side, frequency, replyFrequency, message, distance
		if event and event[1] == modem.IP and event[2] == IP and event[3] == sender_port and event[4] == dest_port then
			if event[5] == "ping" then
				order = 2
				modem.send(IP, dest_port, sender_port,"pong")
				break
			elseif event[5] == "pong" then
				order = 1
				break
			end
		end
	end

	debugPrint("Order: ",order)

	event = {}

	if order == 1 then
		modem.send(IP, dest_port, sender_port, mySecret)
		debugPrint("Sent my secret...")
		repeat
			event = modem.receive("modem_message")
			debugPrint("Got an event: ", pcall(textutils.serialize, event))
		until event and event[1] == modem.IP and event[2] == IP and event[3] == sender_port and event[4] == dest_port
		hisSecret = event[5]
	elseif order == 2 then
		repeat
			event = modem.receive("modem_message")
			debugPrint("Got an event: ", pcall(textutils.serialize, event))
		until event and event[1] == modem.IP and event[2] == IP and event[3] == sender_port and event[4] == dest_port
		hisSecret = event[5]
		modem.send(IP, dest_port, sender_port, mySecret)
		debugPrint("Sent my secret...")
	end
	os.queueEvent("A BigNum event")
	os.pullEventRaw("A BigNum event")
	local pow = hisSecret^secret
	os.queueEvent("A BigNum event")
	os.pullEventRaw("A BigNum event")
	local _,v = BigNum.mt.div(pow,prime)
	os.queueEvent("A BigNum event")
	os.pullEventRaw("A BigNum event")
	return v, order
end

return connect