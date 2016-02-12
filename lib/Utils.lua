--[[
	Utils lib by Creator
]]--

local Delta = ...
local Utils = {}

function Utils.decTo(val,base)
	if val == 0 then return 0 end
	local base, k = base or 10, "0123456789ABCDEFGHIJKLMNOPQRSTUVW"
	local result, d = ""
	while val > 0 do
		val, d = math.floor(val/base), math.fmod(val,base)+1
		result = string.sub(k,d,d)..result
	end
	return result
end

function Utils.toDec(val,base)
	return tonumber(val,base)
end

return Utils