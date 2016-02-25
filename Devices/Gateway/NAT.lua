--[[
	NAT service
]]--

local Delta = ...

local function NAT(globalSide, modems, NAT)
	local event = {}
	local mapLocal = NAT.mapLocal -- to local
	local mapGlobal = NAT.mapGlobal -- to global
	local unMapLocal = NAT.unMapLocal
	local unMapGlobal = NAT.unMapGlobal
	local port, address, ok, err
	print("Started NAT service")

	while true do
		event = {coroutine.yield("modem_message")}
		print("NAT: ",event[1])
		if event[2] ~= globalSide and event[3] == 65535 and type(event[5]) == "table" then
			if event[4] == 0x2 then --map local
				port, address = event[5][1], event[5][1]
				ok, err = mapLocal(port, address)
				if not ok then
					print(err)
				else
					print(ok)
					print("Port: ", port)
					print("Address: ", address)
				end
			elseif event[4] == 0x3 then --map global
				port, address = event[5][1], event[5][1]
				ok, err = mapGlobal(port, address)
				if not ok then
					print(err)
				else
					print(ok)
					print("Port: ", port)
					print("Address: ", address)
				end
			elseif event[4] == 0x4 then --unmap local
				port = event[5][1]
				ok, err = unMapLocal(port)
				if not ok then
					print(err)
				else
					print(ok)
					print("Port: ", port)
					print("Address: ", address)
				end
			elseif event[4] == 0x5 then --unmap global
				address = event[5][1]
				ok, err = unMapGlobal(address)
				if not ok then
					print(err)
				else
					print(ok)
					print("Port: ", port)
					print("Address: ", address)
				end
			end
		end
	end
end

return NAT