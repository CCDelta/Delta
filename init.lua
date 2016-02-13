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
			t[v:match("(%a+)")] = dofile(totalpath..v)
		end
	end
end

local function loadDevice(name)
	
end

Delta.loadFolder = loadFolder
Delta.lib = {}

loadFolder(path.."/lib",Delta.lib)

return Delta