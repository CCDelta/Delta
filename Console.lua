dofile = function(path,...)
	local f = loadfile(path)
	setfenv(f,_G)
	return f(...)
end

local path = ...

local Delta = dofile("disk/Delta/init.lua",path)

local m = Delta.modem("top")

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
	end
}

while continue do
	term.write("> ")
	local r = read(nil,history)
	table.insert(history,r)
	c, b = split(r)
	if commands[c] then
		commands[c](b)
	else
		print("No such command!")
	end
end

print("Exiting Delta Shell...")