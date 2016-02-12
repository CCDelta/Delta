--[[
	Utils lib by Creator
]]--

local Delta = ...
local Utils = {}

function Utils.toBase(val,base,fill)
	if val == 0 then 
		return fill and string.rep("0",fill) or "0"
	end
	local base, k = base or 10, "0123456789ABCDEFGHIJKLMNOPQRSTUVW"
	local result, d = ""
	while val > 0 do
		val, d = math.floor(val/base), math.fmod(val,base)+1
		result = string.sub(k,d,d)..result
	end
	result = result:sub(1,8)
	local todo = fill - #result
	result = string.rep("0",todo)..result
	return result
end

function Utils.toDec(val,base)
	return tonumber(val,base)
end

return Utils