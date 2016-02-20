dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

local modems = {}
local main = ""

local path = ...

local Delta = dofile(path.."/init.lua",path)

local split = function(str)
	local f = str:find(" ") or #str+1
	local command = str:sub(1,f-1)
	local argsstr = str:sub(f+1,-1)
	local args = {}
	for token in argsstr:gmatch("[^%s]+") do
		args[#args+1] = token
	end
	return command:lower(), args
end

term.clear()
term.setCursorPos(1,1)

local history = {}
local c, b
local continue = true

local commands = {
	get = function(a)
		if type(a[1]) == "string" and a[1]:lower() == "mac" then
			print(m.MAC)
		elseif true then

		end
	end,
	exit = function()
		continue = false
	end,
	clear = function()
		term.clear()
		term.setCursorPos(1,1)
	end,
	clr = function()
		term.clear()
		term.setCursorPos(1,1)
	end,
	send = function(a)
		local ok, err = m.send(a[1],a[2])
		if not ok then
			print(err)
		else
			print("Everyhting OK.")
		end
	end,
	receive = function()
		local sender, destination, msg
		while true do
			sender, destination, msg = m.receive()
			if not sender then
				print(destination[1])
			else
				print("Sender: ",sender)
				print("Destination: ",destination)
				print("Message: ",msg)
			end
		end
	end,
	start = function(a)
		local dev = Delta.loadDevice(a[1])
		if not dev then
			print("Fail")
			return false
		end
		dev.run()
	end,
	connect = function()
		modems[main].connect()
		print(modems[main].IP)
	end,
	reload = function()
		Delta = nil
		Delta = dofile(path.."/init.lua",path)
	end,
	set = function(a)
		if type(a[1]) == "string" then
			if  a[1]:lower() == "modem" then
				m = Delta.modem(a[2])
			elseif a[1]:lower() == "main" then
				main = tostring(a[2])
			end
		end
	end,
	add = function(a)
		a[1] = tostring(a[1]):lower()
		modems[a[1]] = Delta.modem(a[1])
		if main == "" then
			main = a[1]
		end
	end
}

function commands.clean()
	pcall(commands.reload,b)
	pcall(commands.clr,b)
end

while continue do
	term.write("> ")
	local r = read(nil,history)
	table.insert(history,r)
	c, b = split(r)
	c = c:lower()
	if commands[c] then
		ok, err = pcall(commands[c],b)
		if not ok then
			print(err)
		end
	else
		print("No such command!")
	end
end

print("Exiting Delta Shell...")