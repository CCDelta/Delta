--[[
	Filesystem
	explorer
	by Creator
]]--

local ignore = {}
local function parse(data)
	for token in string.gmatch(data,"[^\n]+") do
		ignore[#ignore+1] = token
	end
end

local args = {...}
if args[3] and args[3]:sub(1,1) == "$" then
	parse(args[3]:sub(2,-1))
elseif args[3] then
	local file = fs.open(args[3],"r")
	local data = file.readAll()
	file.close()
	parse(data)
end

local filesystem = {}

local function readFile(path)
	local file = fs.open(path,"r")
	local variable = file.readAll()
	file.close()
	return variable
end

local function isNotBanned(path)
	for i,v in pairs(ignore) do
		if v == path then
			return false
		end
	end
	return true
end

local function explore(dir)
	local buffer = {}
	local sBuffer = fs.list(dir)
	for i,v in pairs(sBuffer) do
		sleep(0.05)
		if isNotBanned(dir.."/"..v) then
			if fs.isDir(dir.."/"..v) then
				if v ~= ".git" then
					print("Compressing directory: "..dir.."/"..v)
					buffer[v] = explore(dir.."/"..v)
				end
			else
				print("Compressing file: "..dir.."/"..v)
				buffer[v] = readFile(dir.."/"..v)
			end
		else
			print(dir.."/"..v)
		end
	end
	return buffer
end

append = [[
local function writeFile(path,content)
	local file = fs.open(path,"w")
	file.write(content)
	file.close()
end
function writeDown(input,dir)
		for i,v in pairs(input) do
		if type(v) == "table" then
			writeDown(v,dir.."/"..i)
		elseif type(v) == "string" then
			writeFile(dir.."/"..i,v)
		end
	end
end

args = {...}
if #args == 0 then
	print("Please input a destination folder.")
else
	writeDown(inputTable,args[1])
end
print("Finished installation...")
]]

local filesystem = explore(args[1])
local file = fs.open(args[2],"w")
file.write("inputTable = "..textutils.serialize(filesystem).."\n\n\n\n\n\n\n\n\n"..append)
file.close()