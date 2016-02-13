local Delta = ...
local BigNum = Delta.BigNum
local doDebug

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

function connect(modem, AUTH_CHANNEL, dist, debugArg)
	local prime = BigNum.new("625210769")
	local base = BigNum.new("11")
	local secret = BigNum.new(math.random(1,800))
	local event = {}
	local PING_PORT = 1
	local KEY_EXCHANGE_PORT = 2
	local order
	local _, mySecret = BigNum.mt.div((base^secret),prime)
	local hisSecret
	local dist = dist
	doDebug = debugArg
	
	debugPrint("Loaded everything...")

	modem.open(AUTH_CHANNEL)
	modem.transmit(AUTH_CHANNEL,PING_PORT,"ping")

	debugPrint("Sent ping message...")
	
	while true do
		event = generateEvent(os.pullEvent())
		debugPrint("One more iteration...")
		--event, side, frequency, replyFrequency, message, distance
		if event[1] == "modem_message" and event[4] == PING_PORT then
			if event[5] == "ping" and event[3] == AUTH_CHANNEL and event[4] == PING_PORT then
				order = 2
				modem.transmit(AUTH_CHANNEL,1,"pong")
				distance = event[6]
				break
			elseif event[5] == "pong" and event[3] == AUTH_CHANNEL and event[4] == PING_PORT then
				order = 1
				distance = event[6]
				break
			end
		end
	end

	debugPrint("Order: ",order)

	event = {}

	if order == 1 then
		modem.transmit(AUTH_CHANNEL,KEY_EXCHANGE_PORT,mySecret)
		debugPrint("Sent my secret...")
		repeat
			event = generateEvent(os.pullEvent())
			debugPrint("Got an event: ", textutils.serialize(event))
		until event[1] == "modem_message" and event[3] == AUTH_CHANNEL and event[4] == KEY_EXCHANGE_PORT and checkDist(dist,event)
		hisSecret = event[5]
	elseif order == 2 then
		repeat
			event = generateEvent(os.pullEvent())
			debugPrint("Got an event: ", textutils.serialize(event))
		until event[1] == "modem_message" and event[3] == AUTH_CHANNEL and event[4] == KEY_EXCHANGE_PORT and checkDist(dist,event)
		hisSecret = event[5]
		modem.transmit(AUTH_CHANNEL,KEY_EXCHANGE_PORT,mySecret)
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

return {connect = connect}