local path = ...

path = path.."/"

local Delta = {}

dofile = function(path,...)
	local f, err = loadfile(path)
	if not f then
		print(err)
	end
	setfenv(f,_G)
	return f(...)
end

local function loadFolder(fpath,t)
	local totalpath = fpath.."/"
	for i,v in pairs(fs.list(totalpath)) do
		if fs.isDir(totalpath..v) then
			t[v] = {}
			loadFolder(totalpath..v,t[v])
		else
			t[v:match("(%a+)")] = dofile(totalpath..v,Delta)
		end
	end
end

local function loadDevice(name)
	if fs.exists(path.."Devices/"..name.."/init.lua") then
		return dofile(path.."Devices/"..name.."/init.lua",path.."Devices/"..name.."/",Delta)
	else
		print("Non existent")
		return false
	end
end

Delta.loadFolder = loadFolder
Delta.loadDevice = loadDevice
Delta.dofile = dofile
Delta.lib = {}

Delta.lib.Utils = dofile(path.."lib/Utils.lua", Delta)
loadFolder(path.."lib",Delta.lib)

Delta.modem = dofile(path.."Framework/Modem.lua",Delta)

return Delta