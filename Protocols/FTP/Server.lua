--[[
	Delta Networking FTP Server.
]]--

local path = ...

dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

local Delta = dofile(path.."/init.lua", path)

local permissions = {
	list(string path) 	table fil
	exists(string path) 	boolean e
	isDir
	isReadOnly
	getName
	getDrive
	getSize
	getFreeSpace
	makeDir
	move
	copy
	delete
	combine
	open
	find 	
	getDir 
}