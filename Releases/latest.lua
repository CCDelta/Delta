inputTable = {
  Layers = {
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
      [ "Modem.lua" ] = "--[[\
	Modem wrapper by Creator\
]]--\
\
local Delta = ...\
local SHA = Delta.lib.SHA\
local toBase = Delta.lib.Utils.toBase\
local largest = BigNum.new(\"281474976710597\")\
\
local sides = {\
	top 	= 0,\
	bottom 	= 1,\
	right 	= 2,\
	left 	= 3,\
	front 	= 4,\
	back 	= 5,\
}\
\
return function(side)\
	if not peripheral.getType(side) == \"modem\" then\
		return false, \"No peripheral present on this side!\"\
	end\
	local m = peripheral.wrap(side)\
	local id = os.getComputerID()*6 + sides[side]\
	local mac = toBase(id,2,48)\
	print(mac)\
	print(#mac)\
end",
    },
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
  },
  [ "init.lua" ] = "local path = ...\
\
path = path..\"/\"\
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
local function loadFolder(fpath,t)\
	local totalpath = fpath..\"/\"\
	for i,v in pairs(fs.list(totalpath)) do\
		if fs.isDir(totalpath..v) then\
			t[v] = {}\
			loadFolder(totalpath..v,t[v])\
		else\
			t[v:match(\"(%a+)\")] = dofile(totalpath..v,Delta)\
		end\
	end\
end\
\
local function loadDevice(name)\
	\
end\
\
Delta.loadFolder = loadFolder\
Delta.lib = {}\
\
loadFolder(path..\"/lib\",Delta.lib)\
\
Delta.modem = dofile(path..\"Layers/Physical/Modem.lua\",Delta)\
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
		val, d = math.floor(val/base), (val%base)+1\
		result = string.sub(k,d,d)..result\
	end\
	if fill then\
		result = result:sub(1,fill)\
		local todo = fill - #result\
		result = string.rep(\"0\",todo)..result\
	end\
	return result\
end\
\
function Utils.toDec(val,base)\
	return tonumber(val,base)\
end\
\
return Utils",
    [ "DH.lua" ] = "local Delta = ...\
local BigNum = Delta.BigNum\
local doDebug\
\
local round = function(n)\
	if not n then print(n) error(\"\",2) end\
	return math.floor((n or 0)+.5)\
end\
\
local function checkDist(argument,event)\
	if not argument then\
		return true\
	end\
	return argument == event[6]\
end\
\
local function generateEvent(...)\
	local name, side, channel, port, message, distance = ...\
	return {\
		[1] = name,\
		[2] = side,\
		[3] = channel,\
		[4] = port,\
		[5] = message,\
		[6] = distance,\
	}\
end\
\
local function debugPrint(...)\
	if doDebug then\
		print(...)\
	end\
end\
\
function connect(modem, AUTH_CHANNEL, dist, debugArg)\
	local prime = BigNum.new(\"625210769\")\
	local base = BigNum.new(\"11\")\
	local secret = BigNum.new(math.random(1,800))\
	local event = {}\
	local PING_PORT = 1\
	local KEY_EXCHANGE_PORT = 2\
	local order\
	local _, mySecret = BigNum.mt.div((base^secret),prime)\
	local hisSecret\
	local dist = dist\
	doDebug = debugArg\
	\
	debugPrint(\"Loaded everything...\")\
\
	modem.open(AUTH_CHANNEL)\
	modem.transmit(AUTH_CHANNEL,PING_PORT,\"ping\")\
\
	debugPrint(\"Sent ping message...\")\
	\
	while true do\
		event = generateEvent(os.pullEvent())\
		debugPrint(\"One more iteration...\")\
		--event, side, frequency, replyFrequency, message, distance\
		if event[1] == \"modem_message\" and event[4] == PING_PORT then\
			if event[5] == \"ping\" and event[3] == AUTH_CHANNEL and event[4] == PING_PORT then\
				order = 2\
				modem.transmit(AUTH_CHANNEL,1,\"pong\")\
				distance = event[6]\
				break\
			elseif event[5] == \"pong\" and event[3] == AUTH_CHANNEL and event[4] == PING_PORT then\
				order = 1\
				distance = event[6]\
				break\
			end\
		end\
	end\
\
	debugPrint(\"Order: \",order)\
\
	event = {}\
\
	if order == 1 then\
		modem.transmit(AUTH_CHANNEL,KEY_EXCHANGE_PORT,mySecret)\
		debugPrint(\"Sent my secret...\")\
		repeat\
			event = generateEvent(os.pullEvent())\
			debugPrint(\"Got an event: \", textutils.serialize(event))\
		until event[1] == \"modem_message\" and event[3] == AUTH_CHANNEL and event[4] == KEY_EXCHANGE_PORT and checkDist(dist,event)\
		hisSecret = event[5]\
	elseif order == 2 then\
		repeat\
			event = generateEvent(os.pullEvent())\
			debugPrint(\"Got an event: \", textutils.serialize(event))\
		until event[1] == \"modem_message\" and event[3] == AUTH_CHANNEL and event[4] == KEY_EXCHANGE_PORT and checkDist(dist,event)\
		hisSecret = event[5]\
		modem.transmit(AUTH_CHANNEL,KEY_EXCHANGE_PORT,mySecret)\
		debugPrint(\"Sent my secret...\")\
	end\
	os.queueEvent(\"A BigNum event\")\
	os.pullEventRaw(\"A BigNum event\")\
	local pow = hisSecret^secret\
	os.queueEvent(\"A BigNum event\")\
	os.pullEventRaw(\"A BigNum event\")\
	local _,v = BigNum.mt.div(pow,prime)\
	os.queueEvent(\"A BigNum event\")\
	os.pullEventRaw(\"A BigNum event\")\
	return v, order\
end\
\
return {connect = connect}",
    [ "SHA.lua" ] = "\
--  \
--  Adaptation of the Secure Hashing Algorithm (SHA-244/256)\
--  Found Here: http://lua-users.org/wiki/SecureHashAlgorithm\
--  \
--  Using an adapted version of the bit library\
--  Found Here: https://bitbucket.org/Boolsheet/bslf/src/1ee664885805/bit.lua\
--  \
\
local SHA = {}\
\
local MOD = 2^32\
local MODM = MOD-1\
\
local function memoize(f)\
	local mt = {}\
	local t = setmetatable({}, mt)\
	function mt:__index(k)\
		local v = f(k)\
		t[k] = v\
		return v\
	end\
	return t\
end\
\
local function make_bitop_uncached(t, m)\
	local function bitop(a, b)\
		local res,p = 0,1\
		while a ~= 0 and b ~= 0 do\
			local am, bm = a % m, b % m\
			res = res + t[am][bm] * p\
			a = (a - am) / m\
			b = (b - bm) / m\
			p = p*m\
		end\
		res = res + (a + b) * p\
		return res\
	end\
	return bitop\
end\
\
local function make_bitop(t)\
	local op1 = make_bitop_uncached(t,2^1)\
	local op2 = memoize(function(a) return memoize(function(b) return op1(a, b) end) end)\
	return make_bitop_uncached(op2, 2 ^ (t.n or 1))\
end\
\
local bxor1 = make_bitop({[0] = {[0] = 0,[1] = 1}, [1] = {[0] = 1, [1] = 0}, n = 4})\
\
local function bxor(a, b, c, ...)\
	local z = nil\
	if b then\
		a = a % MOD\
		b = b % MOD\
		z = bxor1(a, b)\
		if c then z = bxor(z, c, ...) end\
		return z\
	elseif a then return a % MOD\
	else return 0 end\
end\
\
local function band(a, b, c, ...)\
	local z\
	if b then\
		a = a % MOD\
		b = b % MOD\
		z = ((a + b) - bxor1(a,b)) / 2\
		if c then z = bit32_band(z, c, ...) end\
		return z\
	elseif a then return a % MOD\
	else return MODM end\
end\
\
local function bnot(x) return (-1 - x) % MOD end\
\
local function rshift1(a, disp)\
	if disp < 0 then return lshift(a,-disp) end\
	return math.floor(a % 2 ^ 32 / 2 ^ disp)\
end\
\
local function rshift(x, disp)\
	if disp > 31 or disp < -31 then return 0 end\
	return rshift1(x % MOD, disp)\
end\
\
local function lshift(a, disp)\
	if disp < 0 then return rshift(a,-disp) end \
	return (a * 2 ^ disp) % 2 ^ 32\
end\
\
local function rrotate(x, disp)\
    x = x % MOD\
    disp = disp % 32\
    local low = band(x, 2 ^ disp - 1)\
    return rshift(x, disp) + lshift(low, 32 - disp)\
end\
\
local k = {\
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,\
	0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,\
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,\
	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,\
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,\
	0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,\
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,\
	0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,\
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,\
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,\
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,\
	0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,\
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,\
	0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,\
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,\
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,\
}\
\
local function str2hexa(s)\
	return (string.gsub(s, \".\", function(c) return string.format(\"%02x\", string.byte(c)) end))\
end\
\
local function num2s(l, n)\
	local s = \"\"\
	for i = 1, n do\
		local rem = l % 256\
		s = string.char(rem) .. s\
		l = (l - rem) / 256\
	end\
	return s\
end\
\
local function s232num(s, i)\
	local n = 0\
	for i = i, i + 3 do n = n*256 + string.byte(s, i) end\
	return n\
end\
\
local function preproc(msg, len)\
	local extra = 64 - ((len + 9) % 64)\
	len = num2s(8 * len, 8)\
	msg = msg .. \"\\128\" .. string.rep(\"\\0\", extra) .. len\
	assert(#msg % 64 == 0)\
	return msg\
end\
\
local function initH256(H)\
	H[1] = 0x6a09e667\
	H[2] = 0xbb67ae85\
	H[3] = 0x3c6ef372\
	H[4] = 0xa54ff53a\
	H[5] = 0x510e527f\
	H[6] = 0x9b05688c\
	H[7] = 0x1f83d9ab\
	H[8] = 0x5be0cd19\
	return H\
end\
\
local function digestblock(msg, i, H)\
	local w = {}\
	for j = 1, 16 do w[j] = s232num(msg, i + (j - 1)*4) end\
	for j = 17, 64 do\
		local v = w[j - 15]\
		local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))\
		v = w[j - 2]\
		w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))\
	end\
\
	local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]\
	for i = 1, 64 do\
		local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))\
		local maj = bxor(band(a, b), band(a, c), band(b, c))\
		local t2 = s0 + maj\
		local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))\
		local ch = bxor (band(e, f), band(bnot(e), g))\
		local t1 = h + s1 + ch + k[i] + w[i]\
		h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2\
	end\
\
	H[1] = band(H[1] + a)\
	H[2] = band(H[2] + b)\
	H[3] = band(H[3] + c)\
	H[4] = band(H[4] + d)\
	H[5] = band(H[5] + e)\
	H[6] = band(H[6] + f)\
	H[7] = band(H[7] + g)\
	H[8] = band(H[8] + h)\
end\
\
function SHA.sha256(msg)\
	msg = preproc(msg, #msg)\
	local H = initH256({})\
	for i = 1, #msg, 64 do digestblock(msg, i, H) end\
	return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) ..\
		num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))\
end\
\
return SHA",
    [ "BigNum.lua" ] = "--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{1\
--\
--  File Name:              bignum.lua\
--  Package Name:           BigNum \
--\
--  Project:    Big Numbers library for Lua\
--  Mantainers: fmp - Frederico Macedo Pessoa\
--              msm - Marco Serpa Molinaro\
--\
--  History:\
--     Version      Autor       Date            Notes\
--      1.1      fmp/msm    12/11/2004   Some bug fixes (thanks Isaac Gouy)\
--      alfa     fmp/msm    03/22/2003   Start of Development\
--      beta     fmp/msm    07/11/2003   Release\
--\
--  Description:\
--    Big numbers manipulation library for Lua.\
--    A Big Number is a table with as many numbers as necessary to represent\
--       its value in base 'RADIX'. It has a field 'len' containing the num-\
--       ber of such numbers and a field 'signal' that may assume the values\
--       '+' and '-'.\
--\
--$.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
\
\
--%%%%%%%%  Constants used in the file %%%%%%%%--{{{1\
   RADIX = 10^7 ;\
   RADIX_LEN = math.floor( math.log10 ( RADIX ) ) ;\
\
\
--%%%%%%%%        Start of Code        %%%%%%%%--\
\
local BigNum = {} ;\
BigNum.mt = {} ;\
\
\
--BigNum.new{{{1\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
--\
--  Function: New \
--\
--\
--  Description:\
--     Creates a new Big Number based on the parameter num.\
--\
--  Parameters:\
--     num - a string, number or BigNumber.\
--\
--  Returns:\
--     A Big Number, or a nil value if an error occured.\
--\
--\
--  %%%%%%%% --\
\
function BigNum.new( num ) --{{{2\
   local bignum = {} ;\
   setmetatable( bignum , BigNum.mt ) ;\
   BigNum.change( bignum , num ) ;\
   return bignum ;\
end\
\
--%%%%%%%%%%%%%%%%%%%% Functions for metatable %%%%%%%%%%%%%%%%%%%%--{{{1\
--BigNum.mt.sub{{{2\
function BigNum.mt.sub( num1 , num2 )\
   local temp = BigNum.new() ;\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   BigNum.sub( bnum1 , bnum2 , temp ) ;\
   return temp ;\
end\
\
--BigNum.mt.add{{{2\
function BigNum.mt.add( num1 , num2 )\
   local temp = BigNum.new() ;\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   BigNum.add( bnum1 , bnum2 , temp ) ;\
   return temp ;\
end\
\
--BigNum.mt.mul{{{2\
function BigNum.mt.mul( num1 , num2 )\
   local temp = BigNum.new() ;\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   BigNum.mul( bnum1 , bnum2 , temp ) ;\
   return temp ;\
end\
\
--BigNum.mt.div{{{2\
function BigNum.mt.div( num1 , num2 )\
   local bnum1 = {} ;\
   local bnum2 = {} ;\
   local bnum3 = BigNum.new() ;\
   local bnum4 = BigNum.new() ;\
   bnum1 = BigNum.new( num1 ) ;\
   bnum2 = BigNum.new( num2 ) ;\
   BigNum.div( bnum1 , bnum2 , bnum3 , bnum4 ) ;\
   return bnum3 , bnum4 ;\
end\
\
--BigNum.mt.tostring{{{2\
function BigNum.mt.tostring( bnum )\
   local i = 0 ;\
   local j = 0 ;\
   local str = \"\" ;\
   local temp = \"\" ;\
   if bnum == nil then\
      return \"nil\" ;\
   elseif bnum.len > 0 then\
      for i = bnum.len - 2 , 0 , -1  do\
         for j = 0 , RADIX_LEN - string.len( bnum[i] ) - 1 do\
            temp = temp .. '0' ;\
         end\
         temp = temp .. bnum[i] ;\
      end\
      temp = bnum[bnum.len - 1] .. temp ;\
      if bnum.signal == '-' then\
         temp = bnum.signal .. temp ;\
      end\
      return temp ;\
   else\
      return \"\" ;\
   end\
end\
\
--BigNum.mt.pow{{{2\
function BigNum.mt.pow( num1 , num2 )\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   return BigNum.pow( bnum1 , bnum2 ) ;\
end\
\
--BigNum.mt.eq{{{2\
function BigNum.mt.eq( num1 , num2 )\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   return BigNum.eq( bnum1 , bnum2 ) ;\
end\
\
--BigNum.mt.lt{{{2\
function BigNum.mt.lt( num1 , num2 )\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   return BigNum.lt( bnum1 , bnum2 ) ;\
end\
\
--BigNum.mt.le{{{2\
function BigNum.mt.le( num1 , num2 )\
   local bnum1 = BigNum.new( num1 ) ;\
   local bnum2 = BigNum.new( num2 ) ;\
   return BigNum.le( bnum1 , bnum2 ) ;\
end\
\
--BigNum.mt.unm{{{2\
function BigNum.mt.unm( num )\
   local ret = BigNum.new( num )\
   if ret.signal == '+' then\
      ret.signal = '-'\
   else\
      ret.signal = '+'\
   end\
   return ret\
end\
\
--%%%%%%%%%%%%%%%%%%%% Metatable Definitions %%%%%%%%%%%%%%%%%%%%--{{{1\
\
BigNum.mt.__metatable = \"hidden\"           ; -- answer to getmetatable(aBignum)\
-- BigNum.mt.__index     = \"inexistent field\" ; -- attempt to acess nil valued field \
-- BigNum.mt.__newindex  = \"not available\"    ; -- attempt to create new field\
BigNum.mt.__tostring  = BigNum.mt.tostring ;\
-- arithmetics\
BigNum.mt.__add = BigNum.mt.add ;\
BigNum.mt.__sub = BigNum.mt.sub ;\
BigNum.mt.__mul = BigNum.mt.mul ;\
BigNum.mt.__div = BigNum.mt.div ;\
BigNum.mt.__pow = BigNum.mt.pow ;\
BigNum.mt.__unm = BigNum.mt.unm ;\
-- Comparisons\
BigNum.mt.__eq = BigNum.mt.eq   ; \
BigNum.mt.__le = BigNum.mt.le   ;\
BigNum.mt.__lt = BigNum.mt.lt   ;\
--concatenation\
-- BigNum.me.__concat = ???\
\
setmetatable( BigNum.mt, { __index = \"inexistent field\", __newindex = \"not available\", __metatable=\"hidden\" } ) ;\
\
--%%%%%%%%%%%%%%%%%%%% Basic Functions %%%%%%%%%%%%%%%%%%%%--{{{1\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: ADD \
--\
--\
--  Description:\
--     Adds two Big Numbers.\
--\
--  Parameters:\
--     bnum1, bnum2 - Numbers to be added.\
--     bnum3 - result\
--\
--  Returns:\
--     0\
--\
--  Exit assertions:\
--     bnum3 is the result of the sum.\
--\
--  %%%%%%%% --\
--Funcao BigNum.add{{{2\
function BigNum.add( bnum1 , bnum2 , bnum3 )\
   local maxlen = 0 ;\
   local i = 0 ;\
   local carry = 0 ;\
   local signal = '+' ;\
   local old_len = 0 ;\
   --Handle the signals\
   if bnum1 == nil or bnum2 == nil or bnum3 == nil then\
      error(\"Function BigNum.add: parameter nil\") ;\
   elseif bnum1.signal == '-' and bnum2.signal == '+' then\
      bnum1.signal = '+' ;\
      BigNum.sub( bnum2 , bnum1 , bnum3 ) ;\
\
      if not rawequal(bnum1, bnum3) then\
         bnum1.signal = '-' ;\
      end\
      return 0 ;\
   elseif bnum1.signal == '+' and bnum2.signal == '-' then   \
      bnum2.signal = '+' ;\
      BigNum.sub( bnum1 , bnum2 , bnum3 ) ;\
      if not rawequal(bnum2, bnum3) then\
         bnum2.signal = '-' ;\
      end\
      return 0 ;\
   elseif bnum1.signal == '-' and bnum2.signal == '-' then\
      signal = '-' ;\
   end\
   --\
   old_len = bnum3.len ;\
   if bnum1.len > bnum2.len then\
      maxlen = bnum1.len ;\
   else\
      maxlen = bnum2.len ;\
      bnum1 , bnum2 = bnum2 , bnum1 ;\
   end\
   --School grade sum\
   for i = 0 , maxlen - 1 do\
      if bnum2[i] ~= nil then\
         bnum3[i] = bnum1[i] + bnum2[i] + carry ;\
      else\
         bnum3[i] = bnum1[i] + carry ;\
      end\
      if bnum3[i] >= RADIX then\
         bnum3[i] = bnum3[i] - RADIX ;\
         carry = 1 ;\
      else\
         carry = 0 ;\
      end\
   end\
   --Update the answer's size\
   if carry == 1 then\
      bnum3[maxlen] = 1 ;\
   end\
   bnum3.len = maxlen + carry ;\
   bnum3.signal = signal ;\
   for i = bnum3.len, old_len do\
      bnum3[i] = nil ;\
   end\
   return 0 ;\
end\
\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: SUB \
--\
--\
--  Description:\
--     Subtracts two Big Numbers.\
--\
--  Parameters:\
--     bnum1, bnum2 - Numbers to be subtracted.\
--     bnum3 - result\
--\
--  Returns:\
--     0\
--\
--  Exit assertions:\
--     bnum3 is the result of the subtraction.\
--\
--  %%%%%%%% --\
--Funcao BigNum.sub{{{2\
function BigNum.sub( bnum1 , bnum2 , bnum3 )\
   local maxlen = 0 ;\
   local i = 0 ;\
   local carry = 0 ;\
   local old_len = 0 ;\
   --Handle the signals\
   \
   if bnum1 == nil or bnum2 == nil or bnum3 == nil then\
      error(\"Function BigNum.sub: parameter nil\") ;\
   elseif bnum1.signal == '-' and bnum2.signal == '+' then\
      bnum1.signal = '+' ;\
      BigNum.add( bnum1 , bnum2 , bnum3 ) ;\
      bnum3.signal = '-' ;\
      if not rawequal(bnum1, bnum3) then\
         bnum1.signal = '-' ;\
      end\
      return 0 ;\
   elseif bnum1.signal == '-' and bnum2.signal == '-' then\
      bnum1.signal = '+' ;\
      bnum2.signal = '+' ;\
      BigNum.sub( bnum2, bnum1 , bnum3 ) ;\
      if not rawequal(bnum1, bnum3) then\
         bnum1.signal = '-' ;\
      end\
      if not rawequal(bnum2, bnum3) then\
         bnum2.signal = '-' ;\
      end\
      return 0 ;\
   elseif bnum1.signal == '+' and bnum2.signal == '-' then\
      bnum2.signal = '+' ;\
      BigNum.add( bnum1 , bnum2 , bnum3 ) ;\
      if not rawequal(bnum2, bnum3) then\
         bnum2.signal = '-' ;\
      end\
      return 0 ;\
   end\
   --Tests if bnum2 > bnum1\
   if BigNum.compareAbs( bnum1 , bnum2 ) == 2 then\
      BigNum.sub( bnum2 , bnum1 , bnum3 ) ;\
      bnum3.signal = '-' ;\
      return 0 ;\
   else\
      maxlen = bnum1.len ;\
   end\
   old_len = bnum3.len ;\
   bnum3.len = 0 ;\
   --School grade subtraction\
   for i = 0 , maxlen - 1 do\
      if bnum2[i] ~= nil then\
         bnum3[i] = bnum1[i] - bnum2[i] - carry ;\
      else\
         bnum3[i] = bnum1[i] - carry ;\
      end\
      if bnum3[i] < 0 then\
         bnum3[i] = RADIX + bnum3[i] ;\
         carry = 1 ;\
      else\
         carry = 0 ;\
      end\
\
      if bnum3[i] ~= 0 then\
         bnum3.len = i + 1 ;\
      end\
   end\
   bnum3.signal = '+' ;\
   --Check if answer's size if zero\
   if bnum3.len == 0 then\
      bnum3.len = 1 ;\
      bnum3[0]  = 0 ;\
   end\
   if carry == 1 then\
      error( \"Error in function sub\" ) ;\
   end\
   for i = bnum3.len , max( old_len , maxlen - 1 ) do\
      bnum3[i] = nil ;\
   end\
   return 0 ;\
end\
\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: MUL \
--\
--\
--  Description:\
--     Multiplies two Big Numbers.\
--\
--  Parameters:\
--     bnum1, bnum2 - Numbers to be multiplied.\
--     bnum3 - result\
--\
--  Returns:\
--     0\
--\
--  Exit assertions:\
--     bnum3 is the result of the multiplication.\
--\
--  %%%%%%%% --\
--BigNum.mul{{{2\
--can't be made in place\
function BigNum.mul( bnum1 , bnum2 , bnum3 )\
   local i = 0 ; j = 0 ;\
   local temp = BigNum.new( ) ;\
   local temp2 = 0 ;\
   local carry = 0 ;\
   local oldLen = bnum3.len ;\
   if bnum1 == nil or bnum2 == nil or bnum3 == nil then\
      error(\"Function BigNum.mul: parameter nil\") ;\
   --Handle the signals\
   elseif bnum1.signal ~= bnum2.signal then\
      BigNum.mul( bnum1 , -bnum2 , bnum3 ) ;\
      bnum3.signal = '-' ;\
      return 0 ;\
   end\
   bnum3.len =  ( bnum1.len ) + ( bnum2.len ) ;\
   --Fill with zeros\
   for i = 1 , bnum3.len do\
      bnum3[i - 1] = 0 ;\
   end\
   --Places nil where passes through this\
   for i = bnum3.len , oldLen do\
      bnum3[i] = nil ;\
   end\
   --School grade multiplication\
   for i = 0 , bnum1.len - 1 do\
      for j = 0 , bnum2.len - 1 do\
         carry =  ( bnum1[i] * bnum2[j] + carry ) ;\
         carry = carry + bnum3[i + j] ;\
         bnum3[i + j] = ( carry % RADIX ) ;\
         temp2 = bnum3[i + j] ;\
         carry =  math.floor ( carry / RADIX ) ;\
      end\
      if carry ~= 0 then\
         bnum3[i + bnum2.len] = carry ;\
      end\
      carry = 0 ;\
   end\
\
   --Update the answer's size\
   for i = bnum3.len - 1 , 1 , -1 do\
      if bnum3[i] ~= nil and bnum3[i] ~= 0 then\
         break ;\
      else\
         bnum3[i] = nil ;\
      end\
      bnum3.len = bnum3.len - 1 ;\
   end\
   return 0 ; \
end\
\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: DIV \
--\
--\
--  Description:\
--     Divides bnum1 by bnum2.\
--\
--  Parameters:\
--     bnum1, bnum2 - Numbers to be divided.\
--     bnum3 - result\
--     bnum4 - remainder\
--\
--  Returns:\
--     0\
--\
--  Exit assertions:\
--     bnum3 is the result of the division.\
--     bnum4 is the remainder of the division.\
--\
--  %%%%%%%% --\
--BigNum.div{{{2\
function BigNum.div( bnum1 , bnum2 , bnum3 , bnum4 )\
   os.queueEvent(\"A BigNum event\")\
   os.pullEventRaw(\"A BigNum event\")\
   local temp = BigNum.new() ;\
   local temp2 = BigNum.new() ;\
   local one = BigNum.new( \"1\" ) ;\
   local zero = BigNum.new( \"0\" ) ;\
   --Check division by zero\
   if BigNum.compareAbs( bnum2 , zero ) == 0 then\
      error( \"Function BigNum.div: Division by zero\" ) ;\
   end     \
   --Handle the signals\
   if bnum1 == nil or bnum2 == nil or bnum3 == nil or bnum4 == nil then\
      error( \"Function BigNum.div: parameter nil\" ) ;\
   elseif bnum1.signal == \"+\" and bnum2.signal == \"-\" then\
      bnum2.signal = \"+\" ;\
      BigNum.div( bnum1 , bnum2 , bnum3 , bnum4 ) ;\
      bnum2.signal = \"-\" ;\
      bnum3.signal = \"-\" ;\
      return 0 ;\
   elseif bnum1.signal == \"-\" and bnum2.signal == \"+\" then\
      bnum1.signal = \"+\" ;\
      BigNum.div( bnum1 , bnum2 , bnum3 , bnum4 ) ;\
      bnum1.signal = \"-\" ;\
      if bnum4 < zero then --Check if remainder is negative\
         BigNum.add( bnum3 , one , bnum3 ) ;\
         BigNum.sub( bnum2 , bnum4 , bnum4 ) ;\
      end\
      bnum3.signal = \"-\" ;\
      return 0 ;\
   elseif bnum1.signal == \"-\" and bnum2.signal == \"-\" then\
      bnum1.signal = \"+\" ;\
      bnum2.signal = \"+\" ;\
      BigNum.div( bnum1 , bnum2 , bnum3 , bnum4 ) ;\
      bnum1.signal = \"-\" ;\
      if bnum4 < zero then --Check if remainder is negative      \
         BigNum.add( bnum3 , one , bnum3 ) ;\
         BigNum.sub( bnum2 , bnum4 , bnum4 ) ;\
      end\
      bnum2.signal = \"-\" ;\
      return 0 ;\
   end\
   temp.len = bnum1.len - bnum2.len - 1 ;\
\
   --Reset variables\
   BigNum.change( bnum3 , \"0\" ) ;\
   BigNum.change( bnum4 , \"0\" ) ; \
\
   BigNum.copy( bnum1 , bnum4 ) ;\
\
   --Check if can continue dividing\
   while( BigNum.compareAbs( bnum4 , bnum2 ) ~= 2 ) do\
      if bnum4[bnum4.len - 1] >= bnum2[bnum2.len - 1] then\
         BigNum.put( temp , math.floor( bnum4[bnum4.len - 1] / bnum2[bnum2.len - 1] ) , bnum4.len - bnum2.len ) ;\
         temp.len = bnum4.len - bnum2.len + 1 ;\
      else\
         BigNum.put( temp , math.floor( ( bnum4[bnum4.len - 1] * RADIX + bnum4[bnum4.len - 2] ) / bnum2[bnum2.len -1] ) , bnum4.len - bnum2.len - 1 ) ;\
         temp.len = bnum4.len - bnum2.len ;\
      end\
    \
      if bnum4.signal ~= bnum2.signal then\
         temp.signal = \"-\";\
      else\
         temp.signal = \"+\";\
      end\
      BigNum.add( temp , bnum3 , bnum3 )  ;\
      temp = temp * bnum2 ;\
      BigNum.sub( bnum4 , temp , bnum4 ) ;\
   end\
\
   --Update if the remainder is negative\
   if bnum4.signal == '-' then\
      decr( bnum3 ) ;\
      BigNum.add( bnum2 , bnum4 , bnum4 ) ;\
   end\
   return 0 ;\
end\
\
--%%%%%%%%%%%%%%%%%%%% Compound Functions %%%%%%%%%%%%%%%%%%%%--{{{1\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: POW / EXP  \
--\
--\
--  Description:\
--     Computes a big number which represents the bnum2-th power of bnum1.\
--\
--  Parameters:\
--     bnum1 - base\
--     bnum2 - expoent\
--\
--  Returns:\
--     Returns a big number which represents the bnum2-th power of bnum1.\
--\
--  %%%%%%%% --\
--BigNum.exp{{{2\
function BigNum.pow( bnum1 , bnum2 )\
   local n = BigNum.new( bnum2 ) ;\
   local y = BigNum.new( 1 ) ;\
   local z = BigNum.new( bnum1 ) ;\
   local zero = BigNum.new( \"0\" ) ;\
   if bnum2 < zero then\
      error( \"Function BigNum.exp: domain error\" ) ;\
   elseif bnum2 == zero then\
      return y ;\
   end\
   while 1 do\
      if( n[0]% 2 ) == 0 then\
         n = n / 2 ;\
      else\
         n = n / 2 ;\
         y = z * y  ;\
         if n == zero then\
            return y ;\
         end\
      end\
      z = z * z ;\
   end\
end\
-- Português :\
BigNum.exp = BigNum.pow\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: GCD / MMC\
--\
--\
--  Description:\
--     Computes the greatest commom divisor of bnum1 and bnum2.\
--\
--  Parameters:\
--     bnum1, bnum2 - positive numbers\
--\
--  Returns:\
--     Returns a big number witch represents the gcd between bnum1 and bnum2.\
--\
--  %%%%%%%% --\
--BigNum.gcd{{{2\
function BigNum.gcd( bnum1 , bnum2 )\
   local a = {} ;\
   local b = {} ;\
   local c = {} ;\
   local d = {} ;\
   local zero = {} ;\
   zero = BigNum.new( \"0\" ) ;\
   if bnum1 == zero or bnum2 == zero then\
      return BigNum.new( \"1\" ) ;\
   end\
   a = BigNum.new( bnum1 ) ;\
   b = BigNum.new( bnum2 ) ;\
   a.signal = '+' ;\
   b.signal = '+' ;\
   c = BigNum.new() ;\
   d = BigNum.new() ;\
   while b > zero do\
      BigNum.div( a , b , c , d ) ;\
      a , b , d = b , d , a ;\
   end\
   return a ;\
end\
-- Português: \
BigNum.mmc = BigNum.gcd\
\
--%%%%%%%%%%%%%%%%%%%% Comparison Functions %%%%%%%%%%%%%%%%%%%%--{{{1\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: EQ\
--\
--\
--  Description:\
--     Compares two Big Numbers.\
--\
--  Parameters:\
--     bnum1, bnum2 - numbers\
--\
--  Returns:\
--     Returns true if they are equal or false otherwise.\
--\
--  %%%%%%%% --\
--BigNum.eq{{{2\
function BigNum.eq( bnum1 , bnum2 )\
   if BigNum.compare( bnum1 , bnum2 ) == 0 then\
      return true ;\
   else\
      return false ;\
   end\
end\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: LT\
--\
--\
--  Description:\
--     Verifies if bnum1 is lesser than bnum2.\
--\
--  Parameters:\
--     bnum1, bnum2 - numbers\
--\
--  Returns:\
--     Returns true if bnum1 is lesser than bnum2 or false otherwise.\
--\
--  %%%%%%%% --\
--BigNum.lt{{{2\
function BigNum.lt( bnum1 , bnum2 )\
   if BigNum.compare( bnum1 , bnum2 ) == 2 then\
      return true ;\
   else\
      return false ;\
   end\
end\
\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: LE\
--\
--\
--  Description:\
--     Verifies if bnum1 is lesser or equal than bnum2.\
--\
--  Parameters:\
--     bnum1, bnum2 - numbers\
--\
--  Returns:\
--     Returns true if bnum1 is lesser or equal than bnum2 or false otherwise.\
--\
--  %%%%%%%% --\
--BigNum.le{{{2\
function BigNum.le( bnum1 , bnum2 )\
   local temp = -1 ;\
   temp = BigNum.compare( bnum1 , bnum2 )\
   if temp == 0 or temp == 2 then\
      return true ;\
   else\
      return false ;\
   end\
end\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: Compare Absolute Values\
--\
--\
--  Description:\
--     Compares absolute values of bnum1 and bnum2.\
--\
--  Parameters:\
--     bnum1, bnum2 - numbers\
--\
--  Returns:\
--     1 - |bnum1| > |bnum2|\
--     2 - |bnum1| < |bnum2|\
--     0 - |bnum1| = |bnum2|\
--\
--  %%%%%%%% --\
--BigNum.compareAbs{{{2\
function BigNum.compareAbs( bnum1 , bnum2 )\
   if bnum1 == nil or bnum2 == nil then\
      error(\"Function compare: parameter nil\") ;\
   elseif bnum1.len > bnum2.len then\
      return 1 ;\
   elseif bnum1.len < bnum2.len then\
      return 2 ;\
   else\
      local i ;\
      for i = bnum1.len - 1 , 0 , -1 do\
         if bnum1[i] > bnum2[i] then\
            return 1 ;\
         elseif bnum1[i] < bnum2[i] then\
            return 2 ;\
         end\
      end\
   end\
   return 0 ;\
end\
\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: Compare \
--\
--\
--  Description:\
--     Compares values of bnum1 and bnum2.\
--\
--  Parameters:\
--     bnum1, bnum2 - numbers\
--\
--  Returns:\
--     1 - |bnum1| > |bnum2|\
--     2 - |bnum1| < |bnum2|\
--     0 - |bnum1| = |bnum2|\
--\
--  %%%%%%%% --\
--BigNum.compare{{{2\
function BigNum.compare( bnum1 , bnum2 )\
   local signal = 0 ;\
   \
   if bnum1 == nil or bnum2 == nil then\
      error(\"Funtion BigNum.compare: parameter nil\") ;\
   elseif bnum1.signal == '+' and bnum2.signal == '-' then\
      return 1 ;\
   elseif bnum1.signal == '-' and bnum2.signal == '+' then\
      return 2 ;\
   elseif bnum1.signal == '-' and bnum2.signal == '-' then\
      signal = 1 ;\
   end\
   if bnum1.len > bnum2.len then\
      return 1 + signal ;\
   elseif bnum1.len < bnum2.len then\
      return 2 - signal ;\
   else\
      local i ;\
      for i = bnum1.len - 1 , 0 , -1 do\
         if bnum1[i] > bnum2[i] then\
            return 1 + signal ;\
	 elseif bnum1[i] < bnum2[i] then\
	    return 2 - signal ;\
	 end\
      end\
   end\
   return 0 ;\
end         \
\
\
--%%%%%%%%%%%%%%%%%%%% Low level Functions %%%%%%%%%%%%%%%%%%%%--{{{1\
--BigNum.copy{{{2\
function BigNum.copy( bnum1 , bnum2 )\
   if bnum1 ~= nil and bnum2 ~= nil then\
      local i ;\
      for i = 0 , bnum1.len - 1 do\
         bnum2[i] = bnum1[i] ;\
      end\
      bnum2.len = bnum1.len ;\
   else\
      error(\"Function BigNum.copy: parameter nil\") ;\
   end\
end\
\
\
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%{{{2\
--\
--  Function: Change\
--\
--  Description:\
--     Changes the value of a BigNum.\
--     This function is called by BigNum.new.\
--\
--  Parameters:\
--     bnum1, bnum2 - numbers\
--\
--  Returns:\
--     1 - |bnum1| > |bnum2|\
--     2 - |bnum1| < |bnum2|\
--     0 - |bnum1| = |bnum2|\
--\
--  %%%%%%%% --\
--BigNum.change{{{2\
function BigNum.change( bnum1 , num )\
   local j = 0 ;\
   local len = 0  ;\
   local num = num ;\
   local l ;\
   local oldLen = 0 ;\
   if bnum1 == nil then\
      error( \"BigNum.change: parameter nil\" ) ;\
   elseif type( bnum1 ) ~= \"table\" then\
      error( \"BigNum.change: parameter error, type unexpected\" ) ;\
   elseif num == nil then\
      bnum1.len = 1 ;\
      bnum1[0] = 0 ;\
      bnum1.signal = \"+\";\
   elseif type( num ) == \"table\" and num.len ~= nil then  --check if num is a big number\
      --copy given table to the new one\
      for i = 0 , num.len do\
         bnum1[i] = num[i] ;\
      end\
      if num.signal ~= '-' and num.signal ~= '+' then\
         bnum1.signal = '+' ;\
      else\
         bnum1.signal = num.signal ;\
      end\
      oldLen = bnum1.len ;\
      bnum1.len = num.len ;\
   elseif type( num ) == \"string\" or type( num ) == \"number\" then\
      if string.sub( num , 1 , 1 ) == '+' or string.sub( num , 1 , 1 ) == '-' then\
         bnum1.signal = string.sub( num , 1 , 1 ) ;\
         num = string.sub(num, 2) ;\
      else\
         bnum1.signal = '+' ;\
      end\
      num = string.gsub( num , \" \" , \"\" ) ;\
      local sf = string.find( num , \"e\" ) ;\
      --Handles if the number is in exp notation\
      if sf ~= nil then\
         num = string.gsub( num , \"%.\" , \"\" ) ;\
         local e = string.sub( num , sf + 1 ) ;\
         e = tonumber(e) ;\
         if e ~= nil and e > 0 then \
            e = tonumber(e) ;\
         else\
            error( \"Function BigNum.change: string is not a valid number\" ) ;\
         end\
         num = string.sub( num , 1 , sf - 2 ) ;\
         for i = string.len( num ) , e do\
            num = num .. \"0\" ;\
         end\
      else\
         sf = string.find( num , \"%.\" ) ;\
         if sf ~= nil then\
            num = string.sub( num , 1 , sf - 1 ) ;\
         end\
      end\
\
      l = string.len( num ) ;\
      oldLen = bnum1.len ;\
      if (l > RADIX_LEN) then\
         local mod = l-( math.floor( l / RADIX_LEN ) * RADIX_LEN ) ;\
         for i = 1 , l-mod, RADIX_LEN do\
            bnum1[j] = tonumber( string.sub( num, -( i + RADIX_LEN - 1 ) , -i ) );\
            --Check if string dosn't represents a number\
            if bnum1[j] == nil then\
               error( \"Function BigNum.change: string is not a valid number\" ) ;\
               bnum1.len = 0 ;\
               return 1 ;\
            end\
            j = j + 1 ; \
            len = len + 1 ;\
         end\
         if (mod ~= 0) then\
            bnum1[j] = tonumber( string.sub( num , 1 , mod ) ) ;\
            bnum1.len = len + 1 ;\
         else\
            bnum1.len = len ;            \
         end\
         --Eliminate trailing zeros\
         for i = bnum1.len - 1 , 1 , -1 do\
            if bnum1[i] == 0 then\
               bnum1[i] = nil ;\
               bnum1.len = bnum1.len - 1 ;\
            else\
               break ;\
            end\
         end\
         \
      else     \
         -- string.len(num) <= RADIX_LEN\
         bnum1[j] = tonumber( num ) ;\
         bnum1.len = 1 ;\
      end\
   else\
      error( \"Function BigNum.change: parameter error, type unexpected\" ) ;\
   end\
\
   --eliminates the deprecated higher order 'algarisms'\
   if oldLen ~= nil then\
      for i = bnum1.len , oldLen do\
         bnum1[i] = nil ;\
      end\
   end\
\
   return 0 ;\
end \
\
--BigNum.put{{{2\
--Places int in the position pos of bignum, fills before with zeroes and\
--after with nil.\
function BigNum.put( bnum , int , pos )\
   if bnum == nil then\
      error(\"Function BigNum.put: parameter nil\") ;\
   end\
   local i = 0 ;\
   for i = 0 , pos - 1 do\
      bnum[i] = 0 ;\
   end\
   bnum[pos] = int ;\
   for i = pos + 1 , bnum.len do\
      bnum[i] = nil ;\
   end\
   bnum.len = pos ;\
   return 0 ;\
end\
\
--printraw{{{2\
function printraw( bnum )\
   local i = 0 ;\
   if bnum == nil then\
      error( \"Function printraw: parameter nil\" ) ;\
   end\
   while 1 == 1 do\
      if bnum[i] == nil then\
         io.write( ' len '..bnum.len ) ;\
         if i ~= bnum.len then\
            io.write( ' ERRO!!!!!!!!' ) ;\
         end\
         io.write( \"\\n\" ) ;\
         return 0 ;\
      end\
      io.write( 'r'..bnum[i] ) ;\
      i = i + 1 ;\
   end\
end\
--max{{{2\
function max( int1 , int2 )\
   if int1 > int2 then\
      return int1 ;\
   else\
      return int2 ;\
   end\
end\
\
--decr{{{2\
function decr( bnum1 )\
   local temp = {} ;\
   temp = BigNum.new( \"1\" ) ;\
   BigNum.sub( bnum1 , temp , bnum1 ) ;\
   return 0 ;\
end\
\
\
--Added by Creator\
\
return BigNum",
    [ "AES.lua" ] = "local Delta = ...\
local AES = {}\
\
local function _W(f) local e=setmetatable({}, {__index = getfenv()}) return setfenv(f,e)() or e end\
local bit=_W(function()\
--[[\
	This bit API is designed to cope with unsigned integers instead of normal integers\
\
	To do this we\
]]\
\
local floor = math.floor\
\
local bit_band, bit_bxor = bit.band, bit.bxor\
local function band(a, b)\
	if a > 2147483647 then a = a - 4294967296 end\
	if b > 2147483647 then b = b - 4294967296 end\
	return bit_band(a, b)\
end\
\
local function bxor(a, b)\
	if a > 2147483647 then a = a - 4294967296 end\
	if b > 2147483647 then b = b - 4294967296 end\
	return bit_bxor(a, b)\
end\
\
local lshift, rshift\
\
rshift = function(a,disp)\
	return floor(a % 4294967296 / 2^disp)\
end\
\
lshift = function(a,disp)\
	return (a * 2^disp) % 4294967296\
end\
\
return {\
	-- bit operations\
	bnot = bit.bnot,\
	band = band,\
	bor  = bit.bor,\
	bxor = bxor,\
	rshift = rshift,\
	lshift = lshift,\
}\
end)\
local gf=_W(function()\
-- finite field with base 2 and modulo irreducible polynom x^8+x^4+x^3+x+1 = 0x11d\
local bxor = bit.bxor\
local lshift = bit.lshift\
\
-- private data of gf\
local n = 0x100\
local ord = 0xff\
local irrPolynom = 0x11b\
local exp = {}\
local log = {}\
\
--\
-- add two polynoms (its simply xor)\
--\
local function add(operand1, operand2)\
	return bxor(operand1,operand2)\
end\
\
--\
-- subtract two polynoms (same as addition)\
--\
local function sub(operand1, operand2)\
	return bxor(operand1,operand2)\
end\
\
--\
-- inverts element\
-- a^(-1) = g^(order - log(a))\
--\
local function invert(operand)\
	-- special case for 1\
	if (operand == 1) then\
		return 1\
	end\
	-- normal invert\
	local exponent = ord - log[operand]\
	return exp[exponent]\
end\
\
--\
-- multiply two elements using a logarithm table\
-- a*b = g^(log(a)+log(b))\
--\
local function mul(operand1, operand2)\
	if (operand1 == 0 or operand2 == 0) then\
		return 0\
	end\
\
	local exponent = log[operand1] + log[operand2]\
	if (exponent >= ord) then\
		exponent = exponent - ord\
	end\
	return  exp[exponent]\
end\
\
--\
-- divide two elements\
-- a/b = g^(log(a)-log(b))\
--\
local function div(operand1, operand2)\
	if (operand1 == 0)  then\
		return 0\
	end\
	-- TODO: exception if operand2 == 0\
	local exponent = log[operand1] - log[operand2]\
	if (exponent < 0) then\
		exponent = exponent + ord\
	end\
	return exp[exponent]\
end\
\
--\
-- print logarithmic table\
--\
local function printLog()\
	for i = 1, n do\
		print(\"log(\", i-1, \")=\", log[i-1])\
	end\
end\
\
--\
-- print exponentiation table\
--\
local function printExp()\
	for i = 1, n do\
		print(\"exp(\", i-1, \")=\", exp[i-1])\
	end\
end\
\
--\
-- calculate logarithmic and exponentiation table\
--\
local function initMulTable()\
	local a = 1\
\
	for i = 0,ord-1 do\
		exp[i] = a\
		log[a] = i\
\
		-- multiply with generator x+1 -> left shift + 1\
		a = bxor(lshift(a, 1), a)\
\
		-- if a gets larger than order, reduce modulo irreducible polynom\
		if a > ord then\
			a = sub(a, irrPolynom)\
		end\
	end\
end\
\
initMulTable()\
\
return {\
	add = add,\
	sub = sub,\
	invert = invert,\
	mul = mul,\
	div = div,\
	printLog = printLog,\
	printExp = printExp,\
}\
end)\
local util=_W(function()\
-- Cache some bit operators\
local bxor = bit.bxor\
local rshift = bit.rshift\
local band = bit.band\
local lshift = bit.lshift\
\
local sleepCheckIn\
--\
-- calculate the parity of one byte\
--\
local function byteParity(byte)\
	byte = bxor(byte, rshift(byte, 4))\
	byte = bxor(byte, rshift(byte, 2))\
	byte = bxor(byte, rshift(byte, 1))\
	return band(byte, 1)\
end\
\
--\
-- get byte at position index\
--\
local function getByte(number, index)\
	if (index == 0) then\
		return band(number,0xff)\
	else\
		return band(rshift(number, index*8),0xff)\
	end\
end\
\
\
--\
-- put number into int at position index\
--\
local function putByte(number, index)\
	if (index == 0) then\
		return band(number,0xff)\
	else\
		return lshift(band(number,0xff),index*8)\
	end\
end\
\
--\
-- convert byte array to int array\
--\
local function bytesToInts(bytes, start, n)\
	local ints = {}\
	for i = 0, n - 1 do\
		ints[i] = putByte(bytes[start + (i*4)    ], 3)\
				+ putByte(bytes[start + (i*4) + 1], 2)\
				+ putByte(bytes[start + (i*4) + 2], 1)\
				+ putByte(bytes[start + (i*4) + 3], 0)\
\
		if n % 10000 == 0 then sleepCheckIn() end\
	end\
	return ints\
end\
\
--\
-- convert int array to byte array\
--\
local function intsToBytes(ints, output, outputOffset, n)\
	n = n or #ints\
	for i = 0, n do\
		for j = 0,3 do\
			output[outputOffset + i*4 + (3 - j)] = getByte(ints[i], j)\
		end\
\
		if n % 10000 == 0 then sleepCheckIn() end\
	end\
	return output\
end\
\
--\
-- convert bytes to hexString\
--\
local function bytesToHex(bytes)\
	local hexBytes = \"\"\
\
	for i,byte in ipairs(bytes) do\
		hexBytes = hexBytes .. string.format(\"%02x \", byte)\
	end\
\
	return hexBytes\
end\
\
--\
-- convert data to hex string\
--\
local function toHexString(data)\
	local type = type(data)\
	if (type == \"number\") then\
		return string.format(\"%08x\",data)\
	elseif (type == \"table\") then\
		return bytesToHex(data)\
	elseif (type == \"string\") then\
		local bytes = {string.byte(data, 1, #data)}\
\
		return bytesToHex(bytes)\
	else\
		return data\
	end\
end\
\
local function padByteString(data)\
	local dataLength = #data\
\
	local random1 = math.random(0,255)\
	local random2 = math.random(0,255)\
\
	local prefix = string.char(random1,\
							   random2,\
							   random1,\
							   random2,\
							   getByte(dataLength, 3),\
							   getByte(dataLength, 2),\
							   getByte(dataLength, 1),\
							   getByte(dataLength, 0))\
\
	data = prefix .. data\
\
	local paddingLength = math.ceil(#data/16)*16 - #data\
	local padding = \"\"\
	for i=1,paddingLength do\
		padding = padding .. string.char(math.random(0,255))\
	end\
\
	return data .. padding\
end\
\
local function properlyDecrypted(data)\
	local random = {string.byte(data,1,4)}\
\
	if (random[1] == random[3] and random[2] == random[4]) then\
		return true\
	end\
\
	return false\
end\
\
local function unpadByteString(data)\
	if (not properlyDecrypted(data)) then\
		return nil\
	end\
\
	local dataLength = putByte(string.byte(data,5), 3)\
					 + putByte(string.byte(data,6), 2)\
					 + putByte(string.byte(data,7), 1)\
					 + putByte(string.byte(data,8), 0)\
\
	return string.sub(data,9,8+dataLength)\
end\
\
local function xorIV(data, iv)\
	for i = 1,16 do\
		data[i] = bxor(data[i], iv[i])\
	end\
end\
\
-- Called every\
local push, pull, time = os.queueEvent, coroutine.yield, os.time\
local oldTime = time()\
local function sleepCheckIn()\
    local newTime = time()\
    if newTime - oldTime >= 0.03 then -- (0.020 * 1.5)\
        oldTime = newTime\
        push(\"sleep\")\
        pull(\"sleep\")\
    end\
end\
\
local function getRandomData(bytes)\
	local char, random, sleep, insert = string.char, math.random, sleepCheckIn, table.insert\
	local result = {}\
\
	for i=1,bytes do\
		insert(result, random(0,255))\
		if i % 10240 == 0 then sleep() end\
	end\
\
	return result\
end\
\
local function getRandomString(bytes)\
	local char, random, sleep, insert = string.char, math.random, sleepCheckIn, table.insert\
	local result = {}\
\
	for i=1,bytes do\
		insert(result, char(random(0,255)))\
		if i % 10240 == 0 then sleep() end\
	end\
\
	return table.concat(result)\
end\
\
return {\
	byteParity = byteParity,\
	getByte = getByte,\
	putByte = putByte,\
	bytesToInts = bytesToInts,\
	intsToBytes = intsToBytes,\
	bytesToHex = bytesToHex,\
	toHexString = toHexString,\
	padByteString = padByteString,\
	properlyDecrypted = properlyDecrypted,\
	unpadByteString = unpadByteString,\
	xorIV = xorIV,\
\
	sleepCheckIn = sleepCheckIn,\
\
	getRandomData = getRandomData,\
	getRandomString = getRandomString,\
}\
end)\
local aes=_W(function()\
-- Implementation of AES with nearly pure lua\
-- AES with lua is slow, really slow :-)\
\
local putByte = util.putByte\
local getByte = util.getByte\
\
-- some constants\
local ROUNDS = 'rounds'\
local KEY_TYPE = \"type\"\
local ENCRYPTION_KEY=1\
local DECRYPTION_KEY=2\
\
-- aes SBOX\
local SBox = {}\
local iSBox = {}\
\
-- aes tables\
local table0 = {}\
local table1 = {}\
local table2 = {}\
local table3 = {}\
\
local tableInv0 = {}\
local tableInv1 = {}\
local tableInv2 = {}\
local tableInv3 = {}\
\
-- round constants\
local rCon = {\
	0x01000000,\
	0x02000000,\
	0x04000000,\
	0x08000000,\
	0x10000000,\
	0x20000000,\
	0x40000000,\
	0x80000000,\
	0x1b000000,\
	0x36000000,\
	0x6c000000,\
	0xd8000000,\
	0xab000000,\
	0x4d000000,\
	0x9a000000,\
	0x2f000000,\
}\
\
--\
-- affine transformation for calculating the S-Box of AES\
--\
local function affinMap(byte)\
	mask = 0xf8\
	result = 0\
	for i = 1,8 do\
		result = bit.lshift(result,1)\
\
		parity = util.byteParity(bit.band(byte,mask))\
		result = result + parity\
\
		-- simulate roll\
		lastbit = bit.band(mask, 1)\
		mask = bit.band(bit.rshift(mask, 1),0xff)\
		if (lastbit ~= 0) then\
			mask = bit.bor(mask, 0x80)\
		else\
			mask = bit.band(mask, 0x7f)\
		end\
	end\
\
	return bit.bxor(result, 0x63)\
end\
\
--\
-- calculate S-Box and inverse S-Box of AES\
-- apply affine transformation to inverse in finite field 2^8\
--\
local function calcSBox()\
	for i = 0, 255 do\
	if (i ~= 0) then\
		inverse = gf.invert(i)\
	else\
		inverse = i\
	end\
		mapped = affinMap(inverse)\
		SBox[i] = mapped\
		iSBox[mapped] = i\
	end\
end\
\
--\
-- Calculate round tables\
-- round tables are used to calculate shiftRow, MixColumn and SubBytes\
-- with 4 table lookups and 4 xor operations.\
--\
local function calcRoundTables()\
	for x = 0,255 do\
		byte = SBox[x]\
		table0[x] = putByte(gf.mul(0x03, byte), 0)\
						  + putByte(             byte , 1)\
						  + putByte(             byte , 2)\
						  + putByte(gf.mul(0x02, byte), 3)\
		table1[x] = putByte(             byte , 0)\
						  + putByte(             byte , 1)\
						  + putByte(gf.mul(0x02, byte), 2)\
						  + putByte(gf.mul(0x03, byte), 3)\
		table2[x] = putByte(             byte , 0)\
						  + putByte(gf.mul(0x02, byte), 1)\
						  + putByte(gf.mul(0x03, byte), 2)\
						  + putByte(             byte , 3)\
		table3[x] = putByte(gf.mul(0x02, byte), 0)\
						  + putByte(gf.mul(0x03, byte), 1)\
						  + putByte(             byte , 2)\
						  + putByte(             byte , 3)\
	end\
end\
\
--\
-- Calculate inverse round tables\
-- does the inverse of the normal roundtables for the equivalent\
-- decryption algorithm.\
--\
local function calcInvRoundTables()\
	for x = 0,255 do\
		byte = iSBox[x]\
		tableInv0[x] = putByte(gf.mul(0x0b, byte), 0)\
							 + putByte(gf.mul(0x0d, byte), 1)\
							 + putByte(gf.mul(0x09, byte), 2)\
							 + putByte(gf.mul(0x0e, byte), 3)\
		tableInv1[x] = putByte(gf.mul(0x0d, byte), 0)\
							 + putByte(gf.mul(0x09, byte), 1)\
							 + putByte(gf.mul(0x0e, byte), 2)\
							 + putByte(gf.mul(0x0b, byte), 3)\
		tableInv2[x] = putByte(gf.mul(0x09, byte), 0)\
							 + putByte(gf.mul(0x0e, byte), 1)\
							 + putByte(gf.mul(0x0b, byte), 2)\
							 + putByte(gf.mul(0x0d, byte), 3)\
		tableInv3[x] = putByte(gf.mul(0x0e, byte), 0)\
							 + putByte(gf.mul(0x0b, byte), 1)\
							 + putByte(gf.mul(0x0d, byte), 2)\
							 + putByte(gf.mul(0x09, byte), 3)\
	end\
end\
\
\
--\
-- rotate word: 0xaabbccdd gets 0xbbccddaa\
-- used for key schedule\
--\
local function rotWord(word)\
	local tmp = bit.band(word,0xff000000)\
	return (bit.lshift(word,8) + bit.rshift(tmp,24))\
end\
\
--\
-- replace all bytes in a word with the SBox.\
-- used for key schedule\
--\
local function subWord(word)\
	return putByte(SBox[getByte(word,0)],0)\
		+ putByte(SBox[getByte(word,1)],1)\
		+ putByte(SBox[getByte(word,2)],2)\
		+ putByte(SBox[getByte(word,3)],3)\
end\
\
--\
-- generate key schedule for aes encryption\
--\
-- returns table with all round keys and\
-- the necessary number of rounds saved in [ROUNDS]\
--\
local function expandEncryptionKey(key)\
	local keySchedule = {}\
	local keyWords = math.floor(#key / 4)\
\
\
	if ((keyWords ~= 4 and keyWords ~= 6 and keyWords ~= 8) or (keyWords * 4 ~= #key)) then\
		print(\"Invalid key size: \", keyWords)\
		return nil\
	end\
\
	keySchedule[ROUNDS] = keyWords + 6\
	keySchedule[KEY_TYPE] = ENCRYPTION_KEY\
\
	for i = 0,keyWords - 1 do\
		keySchedule[i] = putByte(key[i*4+1], 3)\
					   + putByte(key[i*4+2], 2)\
					   + putByte(key[i*4+3], 1)\
					   + putByte(key[i*4+4], 0)\
	end\
\
	for i = keyWords, (keySchedule[ROUNDS] + 1)*4 - 1 do\
		local tmp = keySchedule[i-1]\
\
		if ( i % keyWords == 0) then\
			tmp = rotWord(tmp)\
			tmp = subWord(tmp)\
\
			local index = math.floor(i/keyWords)\
			tmp = bit.bxor(tmp,rCon[index])\
		elseif (keyWords > 6 and i % keyWords == 4) then\
			tmp = subWord(tmp)\
		end\
\
		keySchedule[i] = bit.bxor(keySchedule[(i-keyWords)],tmp)\
	end\
\
	return keySchedule\
end\
\
--\
-- Inverse mix column\
-- used for key schedule of decryption key\
--\
local function invMixColumnOld(word)\
	local b0 = getByte(word,3)\
	local b1 = getByte(word,2)\
	local b2 = getByte(word,1)\
	local b3 = getByte(word,0)\
\
	return putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b1),\
											 gf.mul(0x0d, b2)),\
											 gf.mul(0x09, b3)),\
											 gf.mul(0x0e, b0)),3)\
		 + putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b2),\
											 gf.mul(0x0d, b3)),\
											 gf.mul(0x09, b0)),\
											 gf.mul(0x0e, b1)),2)\
		 + putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b3),\
											 gf.mul(0x0d, b0)),\
											 gf.mul(0x09, b1)),\
											 gf.mul(0x0e, b2)),1)\
		 + putByte(gf.add(gf.add(gf.add(gf.mul(0x0b, b0),\
											 gf.mul(0x0d, b1)),\
											 gf.mul(0x09, b2)),\
											 gf.mul(0x0e, b3)),0)\
end\
\
--\
-- Optimized inverse mix column\
-- look at http://fp.gladman.plus.com/cryptography_technology/rijndael/aes.spec.311.pdf\
-- TODO: make it work\
--\
local function invMixColumn(word)\
	local b0 = getByte(word,3)\
	local b1 = getByte(word,2)\
	local b2 = getByte(word,1)\
	local b3 = getByte(word,0)\
\
	local t = bit.bxor(b3,b2)\
	local u = bit.bxor(b1,b0)\
	local v = bit.bxor(t,u)\
	v = bit.bxor(v,gf.mul(0x08,v))\
	w = bit.bxor(v,gf.mul(0x04, bit.bxor(b2,b0)))\
	v = bit.bxor(v,gf.mul(0x04, bit.bxor(b3,b1)))\
\
	return putByte( bit.bxor(bit.bxor(b3,v), gf.mul(0x02, bit.bxor(b0,b3))), 0)\
		 + putByte( bit.bxor(bit.bxor(b2,w), gf.mul(0x02, t              )), 1)\
		 + putByte( bit.bxor(bit.bxor(b1,v), gf.mul(0x02, bit.bxor(b0,b3))), 2)\
		 + putByte( bit.bxor(bit.bxor(b0,w), gf.mul(0x02, u              )), 3)\
end\
\
--\
-- generate key schedule for aes decryption\
--\
-- uses key schedule for aes encryption and transforms each\
-- key by inverse mix column.\
--\
local function expandDecryptionKey(key)\
	local keySchedule = expandEncryptionKey(key)\
	if (keySchedule == nil) then\
		return nil\
	end\
\
	keySchedule[KEY_TYPE] = DECRYPTION_KEY\
\
	for i = 4, (keySchedule[ROUNDS] + 1)*4 - 5 do\
		keySchedule[i] = invMixColumnOld(keySchedule[i])\
	end\
\
	return keySchedule\
end\
\
--\
-- xor round key to state\
--\
local function addRoundKey(state, key, round)\
	for i = 0, 3 do\
		state[i] = bit.bxor(state[i], key[round*4+i])\
	end\
end\
\
--\
-- do encryption round (ShiftRow, SubBytes, MixColumn together)\
--\
local function doRound(origState, dstState)\
	dstState[0] =  bit.bxor(bit.bxor(bit.bxor(\
				table0[getByte(origState[0],3)],\
				table1[getByte(origState[1],2)]),\
				table2[getByte(origState[2],1)]),\
				table3[getByte(origState[3],0)])\
\
	dstState[1] =  bit.bxor(bit.bxor(bit.bxor(\
				table0[getByte(origState[1],3)],\
				table1[getByte(origState[2],2)]),\
				table2[getByte(origState[3],1)]),\
				table3[getByte(origState[0],0)])\
\
	dstState[2] =  bit.bxor(bit.bxor(bit.bxor(\
				table0[getByte(origState[2],3)],\
				table1[getByte(origState[3],2)]),\
				table2[getByte(origState[0],1)]),\
				table3[getByte(origState[1],0)])\
\
	dstState[3] =  bit.bxor(bit.bxor(bit.bxor(\
				table0[getByte(origState[3],3)],\
				table1[getByte(origState[0],2)]),\
				table2[getByte(origState[1],1)]),\
				table3[getByte(origState[2],0)])\
end\
\
--\
-- do last encryption round (ShiftRow and SubBytes)\
--\
local function doLastRound(origState, dstState)\
	dstState[0] = putByte(SBox[getByte(origState[0],3)], 3)\
				+ putByte(SBox[getByte(origState[1],2)], 2)\
				+ putByte(SBox[getByte(origState[2],1)], 1)\
				+ putByte(SBox[getByte(origState[3],0)], 0)\
\
	dstState[1] = putByte(SBox[getByte(origState[1],3)], 3)\
				+ putByte(SBox[getByte(origState[2],2)], 2)\
				+ putByte(SBox[getByte(origState[3],1)], 1)\
				+ putByte(SBox[getByte(origState[0],0)], 0)\
\
	dstState[2] = putByte(SBox[getByte(origState[2],3)], 3)\
				+ putByte(SBox[getByte(origState[3],2)], 2)\
				+ putByte(SBox[getByte(origState[0],1)], 1)\
				+ putByte(SBox[getByte(origState[1],0)], 0)\
\
	dstState[3] = putByte(SBox[getByte(origState[3],3)], 3)\
				+ putByte(SBox[getByte(origState[0],2)], 2)\
				+ putByte(SBox[getByte(origState[1],1)], 1)\
				+ putByte(SBox[getByte(origState[2],0)], 0)\
end\
\
--\
-- do decryption round\
--\
local function doInvRound(origState, dstState)\
	dstState[0] =  bit.bxor(bit.bxor(bit.bxor(\
				tableInv0[getByte(origState[0],3)],\
				tableInv1[getByte(origState[3],2)]),\
				tableInv2[getByte(origState[2],1)]),\
				tableInv3[getByte(origState[1],0)])\
\
	dstState[1] =  bit.bxor(bit.bxor(bit.bxor(\
				tableInv0[getByte(origState[1],3)],\
				tableInv1[getByte(origState[0],2)]),\
				tableInv2[getByte(origState[3],1)]),\
				tableInv3[getByte(origState[2],0)])\
\
	dstState[2] =  bit.bxor(bit.bxor(bit.bxor(\
				tableInv0[getByte(origState[2],3)],\
				tableInv1[getByte(origState[1],2)]),\
				tableInv2[getByte(origState[0],1)]),\
				tableInv3[getByte(origState[3],0)])\
\
	dstState[3] =  bit.bxor(bit.bxor(bit.bxor(\
				tableInv0[getByte(origState[3],3)],\
				tableInv1[getByte(origState[2],2)]),\
				tableInv2[getByte(origState[1],1)]),\
				tableInv3[getByte(origState[0],0)])\
end\
\
--\
-- do last decryption round\
--\
local function doInvLastRound(origState, dstState)\
	dstState[0] = putByte(iSBox[getByte(origState[0],3)], 3)\
				+ putByte(iSBox[getByte(origState[3],2)], 2)\
				+ putByte(iSBox[getByte(origState[2],1)], 1)\
				+ putByte(iSBox[getByte(origState[1],0)], 0)\
\
	dstState[1] = putByte(iSBox[getByte(origState[1],3)], 3)\
				+ putByte(iSBox[getByte(origState[0],2)], 2)\
				+ putByte(iSBox[getByte(origState[3],1)], 1)\
				+ putByte(iSBox[getByte(origState[2],0)], 0)\
\
	dstState[2] = putByte(iSBox[getByte(origState[2],3)], 3)\
				+ putByte(iSBox[getByte(origState[1],2)], 2)\
				+ putByte(iSBox[getByte(origState[0],1)], 1)\
				+ putByte(iSBox[getByte(origState[3],0)], 0)\
\
	dstState[3] = putByte(iSBox[getByte(origState[3],3)], 3)\
				+ putByte(iSBox[getByte(origState[2],2)], 2)\
				+ putByte(iSBox[getByte(origState[1],1)], 1)\
				+ putByte(iSBox[getByte(origState[0],0)], 0)\
end\
\
--\
-- encrypts 16 Bytes\
-- key           encryption key schedule\
-- input         array with input data\
-- inputOffset   start index for input\
-- output        array for encrypted data\
-- outputOffset  start index for output\
--\
local function encrypt(key, input, inputOffset, output, outputOffset)\
	--default parameters\
	inputOffset = inputOffset or 1\
	output = output or {}\
	outputOffset = outputOffset or 1\
\
	local state = {}\
	local tmpState = {}\
\
	if (key[KEY_TYPE] ~= ENCRYPTION_KEY) then\
		print(\"No encryption key: \", key[KEY_TYPE])\
		return\
	end\
\
	state = util.bytesToInts(input, inputOffset, 4)\
	addRoundKey(state, key, 0)\
\
	local checkIn = util.sleepCheckIn\
\
	local round = 1\
	while (round < key[ROUNDS] - 1) do\
		-- do a double round to save temporary assignments\
		doRound(state, tmpState)\
		addRoundKey(tmpState, key, round)\
		round = round + 1\
\
		doRound(tmpState, state)\
		addRoundKey(state, key, round)\
		round = round + 1\
	end\
\
	checkIn()\
\
	doRound(state, tmpState)\
	addRoundKey(tmpState, key, round)\
	round = round +1\
\
	doLastRound(tmpState, state)\
	addRoundKey(state, key, round)\
\
	return util.intsToBytes(state, output, outputOffset)\
end\
\
--\
-- decrypt 16 bytes\
-- key           decryption key schedule\
-- input         array with input data\
-- inputOffset   start index for input\
-- output        array for decrypted data\
-- outputOffset  start index for output\
---\
local function decrypt(key, input, inputOffset, output, outputOffset)\
	-- default arguments\
	inputOffset = inputOffset or 1\
	output = output or {}\
	outputOffset = outputOffset or 1\
\
	local state = {}\
	local tmpState = {}\
\
	if (key[KEY_TYPE] ~= DECRYPTION_KEY) then\
		print(\"No decryption key: \", key[KEY_TYPE])\
		return\
	end\
\
	state = util.bytesToInts(input, inputOffset, 4)\
	addRoundKey(state, key, key[ROUNDS])\
\
	local checkIn = util.sleepCheckIn\
\
	local round = key[ROUNDS] - 1\
	while (round > 2) do\
		-- do a double round to save temporary assignments\
		doInvRound(state, tmpState)\
		addRoundKey(tmpState, key, round)\
		round = round - 1\
\
		doInvRound(tmpState, state)\
		addRoundKey(state, key, round)\
		round = round - 1\
\
		if round % 32 == 0 then\
			checkIn()\
		end\
	end\
\
	checkIn()\
\
	doInvRound(state, tmpState)\
	addRoundKey(tmpState, key, round)\
	round = round - 1\
\
	doInvLastRound(tmpState, state)\
	addRoundKey(state, key, round)\
\
	return util.intsToBytes(state, output, outputOffset)\
end\
\
-- calculate all tables when loading this file\
calcSBox()\
calcRoundTables()\
calcInvRoundTables()\
\
return {\
	ROUNDS = ROUNDS,\
	KEY_TYPE = KEY_TYPE,\
	ENCRYPTION_KEY = ENCRYPTION_KEY,\
	DECRYPTION_KEY = DECRYPTION_KEY,\
\
	expandEncryptionKey = expandEncryptionKey,\
	expandDecryptionKey = expandDecryptionKey,\
	encrypt = encrypt,\
	decrypt = decrypt,\
}\
end)\
local buffer=_W(function()\
local function new ()\
	return {}\
end\
\
local function addString (stack, s)\
	table.insert(stack, s)\
	for i = #stack - 1, 1, -1 do\
		if #stack[i] > #stack[i+1] then\
				break\
		end\
		stack[i] = stack[i] .. table.remove(stack)\
	end\
end\
\
local function toString (stack)\
	for i = #stack - 1, 1, -1 do\
		stack[i] = stack[i] .. table.remove(stack)\
	end\
	return stack[1]\
end\
\
return {\
	new = new,\
	addString = addString,\
	toString = toString,\
}\
end)\
local ciphermode=_W(function()\
local public = {}\
\
--\
-- Encrypt strings\
-- key - byte array with key\
-- string - string to encrypt\
-- modefunction - function for cipher mode to use\
--\
function public.encryptString(key, data, modeFunction)\
	local iv = iv or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}\
	local keySched = aes.expandEncryptionKey(key)\
	local encryptedData = buffer.new()\
\
	for i = 1, #data/16 do\
		local offset = (i-1)*16 + 1\
		local byteData = {string.byte(data,offset,offset +15)}\
\
		modeFunction(keySched, byteData, iv)\
\
		buffer.addString(encryptedData, string.char(unpack(byteData)))\
	end\
\
	return buffer.toString(encryptedData)\
end\
\
--\
-- the following 4 functions can be used as\
-- modefunction for encryptString\
--\
\
-- Electronic code book mode encrypt function\
function public.encryptECB(keySched, byteData, iv)\
	aes.encrypt(keySched, byteData, 1, byteData, 1)\
end\
\
-- Cipher block chaining mode encrypt function\
function public.encryptCBC(keySched, byteData, iv)\
	util.xorIV(byteData, iv)\
\
	aes.encrypt(keySched, byteData, 1, byteData, 1)\
\
	for j = 1,16 do\
		iv[j] = byteData[j]\
	end\
end\
\
-- Output feedback mode encrypt function\
function public.encryptOFB(keySched, byteData, iv)\
	aes.encrypt(keySched, iv, 1, iv, 1)\
	util.xorIV(byteData, iv)\
end\
\
-- Cipher feedback mode encrypt function\
function public.encryptCFB(keySched, byteData, iv)\
	aes.encrypt(keySched, iv, 1, iv, 1)\
	util.xorIV(byteData, iv)\
\
	for j = 1,16 do\
		iv[j] = byteData[j]\
	end\
end\
\
--\
-- Decrypt strings\
-- key - byte array with key\
-- string - string to decrypt\
-- modefunction - function for cipher mode to use\
--\
function public.decryptString(key, data, modeFunction)\
	local iv = iv or {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}\
\
	local keySched\
	if (modeFunction == public.decryptOFB or modeFunction == public.decryptCFB) then\
		keySched = aes.expandEncryptionKey(key)\
	else\
		keySched = aes.expandDecryptionKey(key)\
	end\
\
	local decryptedData = buffer.new()\
\
	for i = 1, #data/16 do\
		local offset = (i-1)*16 + 1\
		local byteData = {string.byte(data,offset,offset +15)}\
\
		iv = modeFunction(keySched, byteData, iv)\
\
		buffer.addString(decryptedData, string.char(unpack(byteData)))\
	end\
\
	return buffer.toString(decryptedData)\
end\
\
--\
-- the following 4 functions can be used as\
-- modefunction for decryptString\
--\
\
-- Electronic code book mode decrypt function\
function public.decryptECB(keySched, byteData, iv)\
\
	aes.decrypt(keySched, byteData, 1, byteData, 1)\
\
	return iv\
end\
\
-- Cipher block chaining mode decrypt function\
function public.decryptCBC(keySched, byteData, iv)\
	local nextIV = {}\
	for j = 1,16 do\
		nextIV[j] = byteData[j]\
	end\
\
	aes.decrypt(keySched, byteData, 1, byteData, 1)\
	util.xorIV(byteData, iv)\
\
	return nextIV\
end\
\
-- Output feedback mode decrypt function\
function public.decryptOFB(keySched, byteData, iv)\
	aes.encrypt(keySched, iv, 1, iv, 1)\
	util.xorIV(byteData, iv)\
\
	return iv\
end\
\
-- Cipher feedback mode decrypt function\
function public.decryptCFB(keySched, byteData, iv)\
	local nextIV = {}\
	for j = 1,16 do\
		nextIV[j] = byteData[j]\
	end\
\
	aes.encrypt(keySched, iv, 1, iv, 1)\
\
	util.xorIV(byteData, iv)\
\
	return nextIV\
end\
\
return public\
end)\
--@require lib/ciphermode.lua\
--@require lib/util.lua\
--\
-- Simple API for encrypting strings.\
--\
AES.AES128 = 16\
AES.AES192 = 24\
AES.AES256 = 32\
\
AES.ECBMODE = 1\
AES.CBCMODE = 2\
AES.OFBMODE = 3\
AES.CFBMODE = 4\
\
local function pwToKey(password, keyLength)\
	local padLength = keyLength\
	if (keyLength == AES.AES192) then\
		padLength = 32\
	end\
	\
	if (padLength > #password) then\
		local postfix = \"\"\
		for i = 1,padLength - #password do\
			postfix = postfix .. string.char(0)\
		end\
		password = password .. postfix\
	else\
		password = string.sub(password, 1, padLength)\
	end\
	\
	local pwBytes = {string.byte(password,1,#password)}\
	password = ciphermode.encryptString(pwBytes, password, ciphermode.encryptCBC)\
	\
	password = string.sub(password, 1, keyLength)\
   \
	return {string.byte(password,1,#password)}\
end\
\
--\
-- Encrypts string data with password password.\
-- password  - the encryption key is generated from this string\
-- data      - string to encrypt (must not be too large)\
-- keyLength - length of aes key: 128(default), 192 or 256 Bit\
-- mode      - mode of encryption: ecb, cbc(default), ofb, cfb \
--\
-- mode and keyLength must be the same for encryption and decryption.\
--\
function AES.encrypt(password, data, keyLength, mode)\
	assert(password ~= nil, \"Empty password.\")\
	assert(password ~= nil, \"Empty data.\")\
	 \
	local mode = mode or AES.CBCMODE\
	local keyLength = keyLength or AES.AES128\
\
	local key = pwToKey(password, keyLength)\
\
	local paddedData = util.padByteString(data)\
	\
	if (mode == AES.ECBMODE) then\
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptECB)\
	elseif (mode == AES.CBCMODE) then\
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptCBC)\
	elseif (mode == AES.OFBMODE) then\
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptOFB)\
	elseif (mode == AES.CFBMODE) then\
		return ciphermode.encryptString(key, paddedData, ciphermode.encryptCFB)\
	else\
		return nil\
	end\
end\
\
\
\
\
--\
-- Decrypts string data with password password.\
-- password  - the decryption key is generated from this string\
-- data      - string to encrypt\
-- keyLength - length of aes key: 128(default), 192 or 256 Bit\
-- mode      - mode of decryption: ecb, cbc(default), ofb, cfb \
--\
-- mode and keyLength must be the same for encryption and decryption.\
--\
function AES.decrypt(password, data, keyLength, mode)\
	local mode = mode or AES.CBCMODE\
	local keyLength = keyLength or AES.AES128\
\
	local key = pwToKey(password, keyLength)\
	\
	local plain\
	if (mode == AES.ECBMODE) then\
		plain = ciphermode.decryptString(key, data, ciphermode.decryptECB)\
	elseif (mode == AES.CBCMODE) then\
		plain = ciphermode.decryptString(key, data, ciphermode.decryptCBC)\
	elseif (mode == AES.OFBMODE) then\
		plain = ciphermode.decryptString(key, data, ciphermode.decryptOFB)\
	elseif (mode == AES.CFBMODE) then\
		plain = ciphermode.decryptString(key, data, ciphermode.decryptCFB)\
	end\
	\
	result = util.unpadByteString(plain)\
	\
	if (result == nil) then\
		return nil\
	end\
	\
	return result\
end\
\
--I (Creator )added this\
\
function AES.encryptBytes(...)\
	return {AES.encrypt(...):byte(1,-1)}\
end\
\
function AES.decryptBytes(a,i,o,n)\
	return AES.decrypt(a,string.char(unpack(i)),o,n)\
end\
\
return AES",
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
