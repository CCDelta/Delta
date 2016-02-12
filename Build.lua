local path, version = ...

print("Path: "..path)
print("Version: "..version)

assert(path, "The path is required! (Argument 1)")
assert(version, "The version is required! (Argument 2)")

local escape = {
	path.."/Test",
	path.."/Releases",
	path.."/Compress.lua",
	path.."/README.md",
	path.."/Build.lua"

}

local escapeStr = table.concat( escape, "\n")

shell.run(path.."/Compress.lua",path,path.."/Releases/"..version..".lua", "$"..escapeStr)

fs.delete(path.."/Releases/latest.lua")
fs.copy(path.."/Releases/"..version..".lua",path.."/Releases/latest.lua")
