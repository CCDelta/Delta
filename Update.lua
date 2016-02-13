--[[
	Updater Script
]]--

local path = ...
print(path)

local handle = http.get("https://raw.githubusercontent.com/ccTCP/Delta/master/Releases/latest.lua")
local f = loadstring(handle.readAll())
setfenv(f,_G)
f(path)

--Just a test