inputTable = {
  Layers = {
    Network = {
      [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
      [ "Address.lua" ] = "--[[\
	IP lib by Creator\
]]--\
\
local Delta = ...\
\
local IP = {}\
\
function IP.new(input)\
	assert(type(input) == \"string\")\
	local address, length = input:match(\"([^/]+)/([^/]+)\")\
	address = input:find(\"/\") and address or input\
	local one, two, three, four = address:match(\"([^%.]+)%.([^%.]+)%.([^%.]+)%.([^%.]+)\")\
	local binary = Delta.Utils.toBase(tonumber(one),2,8)..Delta.Utils.toBase(tonumber(two),2,8)..Delta.Utils.toBase(tonumber(three),2,8)..Delta.Utils.toBase(tonumber(four),2,8)\
	local network, host\
	if length then\
		network, host = binary:sub(1,length), binary:sub(length+1,-1)\
	end\
	return {\
		[1] = one, \
		[2] = two, \
		[3] = three,\
		[4] = four,\
		length = length,\
		binary = binary,\
		network = network,\
		host = host,\
		original = input,\
	}\
end\
\
IP.reserved = {\
	[0] = IP.new(\"0.0.0.0/8\"), 			--0x0		Current network (only valid as source address) 	RFC 6890\
	[1] = IP.new(\"10.0.0.0/8\"), 		--0x1		Private network 	RFC 1918\
	[2] = IP.new(\"100.64.0.0/10\"), 		--0x2		Shared Address Space 	RFC 6598\
	[3] = IP.new(\"127.0.0.0/8\"), 		--0x3		Loopback 	RFC 6890\
	[4] = IP.new(\"169.254.0.0/16\"), 	--0x4		Link-local 	RFC 3927\
	[5] = IP.new(\"172.16.0.0/12\"), 		--0x5		Private network 	RFC 1918\
	[6] = IP.new(\"192.0.0.0/24\"), 		--0x6		IETF Protocol Assignments 	RFC 6890\
	[7] = IP.new(\"192.0.2.0/24\"), 		--0x7		TEST-NET-1, documentation and examples 	RFC 5737\
	[8] = IP.new(\"192.88.99.0/24\"), 	--0x8		IPv6 to IPv4 relay 	RFC 3068\
	[9] = IP.new(\"192.168.0.0/16\"), 	--0x9		Private network 	RFC 1918\
	[10] = IP.new(\"198.18.0.0/15\"), 	--0xa		Network benchmark tests 	RFC 2544\
	[11] = IP.new(\"198.51.100.0/24\"), 	--0xb		TEST-NET-2, documentation and examples 	RFC 5737\
	[12] = IP.new(\"203.0.113.0/24\"), 	--0xc		TEST-NET-3, documentation and examples 	RFC 5737\
	[13] = IP.new(\"224.0.0.0/4\"), 		--0xd		IP multicast (former Class D network) 	RFC 5771\
	[14] = IP.new(\"240.0.0.0/4\"), 		--0xe		Reserved (former Class E network) 	RFC 1700\
	[15] = IP.new(\"255.255.255.255/32\"), 	--0xf		Broadcast	RFC 919\
}\
\
function IP.isReserved(address)\
	local b = address.binary\
	local l\
	for i=0,15 do\
		l = IP.reserved[i]\
		if b:sub(1,l.length)==l.network then\
			return i\
		end\
	end\
end\
\
return IP",
    },
    Physical = {
      [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
      [ "Modem.lua" ] = "",
    },
    [ "Data Link" ] = {
      [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
    },
    [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
  },
  [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
local function loadFolder()\
\
end\
\
return Delta",
  [ "LICENSE.md" ] = "\
The MIT License (MIT)\
\
Copyright (c) 2016 Creator\
\
Permission is hereby granted, free of charge, to any person obtaining a copy\
of this software and associated documentation files (the \"Software\"), to deal\
in the Software without restriction, including without limitation the rights\
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\
copies of the Software, and to permit persons to whom the Software is\
furnished to do so, subject to the following conditions:\
\
The above copyright notice and this permission notice shall be included in all\
copies or substantial portions of the Software.\
\
THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\
SOFTWARE.",
  Devices = {
    Gateway = {
      [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
    },
    Switch = {
      [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
    },
    Router = {
      [ "init.lua" ] = "local path = ...\
\
print(path)\
\
local Delta = {}\
\
dofile = function(path,...)\
	local f, err = loadfile(path)\
	if not f then\
		print(err)\
	end\
	setfenv(f,_G)\
	return f(...)\
end\
\
Delta.Utils, err = dofile(path..\"/lib/Utils.lua\", Delta)\
Delta.IP, err = dofile(path..\"/lib/IP.lua\", Delta)\
\
return Delta",
    },
  },
  [ "Update.lua" ] = "--[[\
	Updater Script\
]]--\
\
local path = ...\
print(path)\
\
local handle = http.get(\"https://raw.githubusercontent.com/ccTCP/Delta/master/Releases/latest.lua\")\
local f = loadstring(handle.readAll())\
setfenv(f,_G)\
f(path)\
\
--Just a test",
  [ ".gitignore" ] = "# Windows image file caches\
Thumbs.db\
ehthumbs.db\
\
# Folder config file\
Desktop.ini\
\
# Recycle Bin used on file shares\
$RECYCLE.BIN/\
\
# Windows Installer files\
*.cab\
*.msi\
*.msm\
*.msp\
\
# Windows shortcuts\
*.lnk\
\
# =========================\
# Operating System Files\
# =========================\
\
# OSX\
# =========================\
\
.DS_Store\
.AppleDouble\
.LSOverride\
\
# Thumbnails\
._*\
\
# Files that might appear in the root of a volume\
.DocumentRevisions-V100\
.fseventsd\
.Spotlight-V100\
.TemporaryItems\
.Trashes\
.VolumeIcon.icns\
\
# Directories potentially created on remote AFP share\
.AppleDB\
.AppleDesktop\
Network Trash Folder\
Temporary Items\
.apdisk",
  lib = {
    [ "Utils.lua" ] = "--[[\
	Utils lib by Creator\
]]--\
\
local Delta = ...\
local Utils = {}\
\
function Utils.toBase(val,base,fill)\
	if val == 0 then \
		return fill and string.rep(\"0\",fill) or \"0\"\
	end\
	local base, k = base or 10, \"0123456789ABCDEFGHIJKLMNOPQRSTUVW\"\
	local result, d = \"\"\
	while val > 0 do\
		val, d = math.floor(val/base), math.fmod(val,base)+1\
		result = string.sub(k,d,d)..result\
	end\
	result = result:sub(1,8)\
	local todo = fill - #result\
	result = string.rep(\"0\",todo)..result\
	return result\
end\
\
function Utils.toDec(val,base)\
	return tonumber(val,base)\
end\
\
return Utils",
  },
  [ ".gitattributes" ] = "# Auto detect text files and perform LF normalization\
* text=auto\
\
# Custom for Visual Studio\
*.cs     diff=csharp\
\
# Standard to msysgit\
*.doc	 diff=astextplain\
*.DOC	 diff=astextplain\
*.docx diff=astextplain\
*.DOCX diff=astextplain\
*.dot  diff=astextplain\
*.DOT  diff=astextplain\
*.pdf  diff=astextplain\
*.PDF	 diff=astextplain\
*.rtf	 diff=astextplain\
*.RTF	 diff=astextplain",
}








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
