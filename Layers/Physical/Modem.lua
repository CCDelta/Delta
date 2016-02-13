--[[
	Modem wrapper by Creator
]]--

local Delta = ...
local SHA = Delta.lib.SHA
local BigNum = Delta.lib.BigNum
local toBase = Delta.lib.Utils.toBase
local bxor = bit.bxor
local largest = BigNum.new("281474976710597")

local sides = {
	top 	= 0,
	bottom 	= 1,
	right 	= 2,
	left 	= 3,
	front 	= 4,
	back 	= 5,
}

return function(side)
	if not peripheral.getType(side) == "modem" then
		return false, "No peripheral present on this side!"
	end
	local m = peripheral.wrap(side)
	local id = os.getComputerID()*6 + sides[side]
	local s = SHA.sha256(tostring(id))
	local _1 = tonumber("0x"..s:sub(1,16))
	local _2 = tonumber("0x"..s:sub(17,32))
	local _3 = tonumber("0x"..s:sub(33,48))
	local _4 = tonumber("0x"..s:sub(49,64))
	local _64bit = tostring(bxor(bxor(_1,_2),bxor(_3,_4)))
	print(_64bit)
end