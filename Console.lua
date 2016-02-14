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
		print(token)
	end
end

term.clear()
term.setCursorPos(1,1)

local history = {}

while true do
	term.write("> ")
	local r = read(nil,history)
	table.insert(history,r)
	split(r)
end
