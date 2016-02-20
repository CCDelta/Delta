--[[
	Switching Service
]]--

local Delta = ...

local function wrap(side)
	if peripheral.isPresent(side) then
		if peripheral.getType(side) == "modem" then
			if peripheral.call(side,"isWireless") == false then
				return Delta.modem(side)
			end
		end
	end
	return nil
end

local function Switch()
	local MainSide
	local MainIP
	local modems = {
		top = wrap("top"),
		bottom = wrap("bottom"),
		front = wrap("front"),
		back = wrap("back"),
		right = wrap("right"),
		left = wrap("left"),
	}

	for i,v in pairs(modems) do
		istrue = v.connect()
		print(i, ": ", istrue)
		if istrue then
			MainSide = i
			MainIP = v.IP
		end
		v.open(65535)
		v.open(65534)
		v.open(64511)
	end

	print(MainSide)

	for i,v in pairs(modems) do
		v.setIP(MainIP)
	end

	local ips = {

	}
	local macs = {

	}
	
	local side, protocol, req_id, message, s

	while true do
		event = {coroutine.yield("modem_message")}
		if event[1] == "modem_message" then
			print("Processing message...")
			side, protocol, req_id, message = event[2], event[3], event[4], event[5]
			if protocol == 65535 then
				if not (side == MainSide) then
					modems[MainSide].transmit(65535, 0x0, message)
					print("Protocol 65535...")
					macs[message] = side
				end
			elseif protocol == 65534 then
				if side == MainSide then
					s = macs[message[1]]
					if s then
						modems[s].transmit(65534, 0x1, message)
						print("Protocol 65534...")
					end
				end
			end
		end
	end
end

return Switch