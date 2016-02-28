--[[
	Server Setup
]]--

local default = [[
list:admin
exists:admin
isDir:admin
isReadOnly:admin
getSize:admin
getFreeSpace:admin
makeDir:admin
move:admin
copy:admin
delete:admin
combine:admin
open:admin
find:admin
getDir:admin
]]

local file = fs.open(".ftp/permissions","w")
file.write(default)
file.close()