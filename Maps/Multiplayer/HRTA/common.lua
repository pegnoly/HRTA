
CREATURE_POWER = {41,72,140,199,201,287,524,716,1086,1487,2185,2520,4866,6153,
	75,124,101,150,259,370,511,694,1069,1415,2102,2360,4868,5850,
	54,84,105,150,232,327,518,739,1166,1539,2204,2588,3174,3905,
	100,169,191,311,309,433,635,846,1072,1441,1717,1993,4942,6028,
	63,105,113,172,243,357,498,643,839,1126,2108,2535,4822,6095,
	180,295,333,484,342,474,598,812,968,1324,2193,2537,5235,6443,
	829,795,856,813,1793,2560,8576,
	70,115,115,171,304,419,318,434,932,1308,2109,2477,4883,6100,
	72,203,299,697,1523,2520,6003,
	355,671,2523,1542,
	42,69,121,174,190,254,492,680,695,926,2058,2571,4790,5937,
	127,149,338,680,1434,2448,5860,
	290,477,488,833,1333,2622,6389,
	174,308,447,862,1457,2032,5905,
	85,145,331,757,1541,2449,3872,
	105,180,355,642,1096,2581,6095,
	113,171,422,434,1329,2437,6070,
	66,181,265,692,895,2572,5937}



function GetPRNGSeed(state)
	local col, row = 1, 4
	local seed = {0, 0, 0, 0, 0, 0}
	for i=1,6 do
		local p2 = 1
		for j=1,24 do
			seed[i] = seed[i] + p2 * state[row][col]
			p2 = p2 * 2
			row = row - 1
			if row < 1 then row, col = 4, col + 1 end
			if col > 32 then break end
		end
		if col > 32 then break end
	end
	return seed
end

function SetPRNGSeed(state, seeds)
	state = state or {}
	seeds = seeds or {}
	for i=1,4 do
		if not state[i] then
			state[i] = {}
		end
		for j=1,32 do
			state[i][j] = 1 -- prevent zero seed when seed not passed
		end
	end
	local col, row = 1, 4
	local test = 0
	for i=1,6 do
		local si = seeds[i] or 16777215
		for j=1,24 do
			local bit = mod(si, 2)
			si = (si - bit) * 0.5
			test = test + bit
			state[row][col] = bit
			row = row - 1
			if row < 1 then row, col = 4, col + 1 end
			if col > 32 then break end
		end
		if col > 32 then break end
	end
	if test == 0 then
		_ERRORMESSAGE('cannot seed xorshift PRNG with zero')
		return nil
	end
	return state
end

function NewPRNG(seeds)
	local state = SetPRNGSeed({}, seeds)
	local random = function(n, m)
		local state = %state
		local s
		local t = state[4]
		for i=1,21 do  -- t = t xor (t << 11)
			t[i] = t[i] ~= t[i+11] or 0
		end
		for i=32,9,-1 do  -- t = t xor (t >> 8)
			t[i] = t[i] ~= t[i-8] or 0
		end
		state[4] = state[3]
		state[3] = state[2]
		s = state[1]
		state[2] = s
		for i=1,32 do  -- t = t xor s
			t[i] = t[i] ~= s[i] or 0
		end
		for i=32,20,-1 do  -- t = t xor (s >> 19)
			t[i] = t[i] ~= s[i-19] or 0
		end
		state[1] = t
		local r = 0
		local p = 1
		for i=24,1,-1 do
			r = r + p * t[i]
			p = p * 2
		end
		r = r / 16777216
		if n then
			if not m then
				n, m = 1, n
			end
			return n + floor(r * (m - n + 1))
		else
			return r
		end
	end
	return random, state
end

do
	local hexnum = {[0]='0'; '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
	
	function hex(n, digits)
		n = intg(n)
		local s = ''
		for i = 1, digits or 6 do
			local rem = mod(n, 16)
			s = %hexnum[rem] .. s
			n = (n - rem) / 16
		end
		return s
	end
end

do
	local env = {
		limit = 1000,  -- ограничение на количество символов
		byte = {["\0"] = 0, ["\1"] = 1, ["\2"] = 2, ["\3"] = 3, ["\4"] = 4, ["\5"] = 5, ["\6"] = 6, ["\7"] = 7, ["\8"] = 8, ["\9"] = 9, ["\n"] = 10, ["\11"] = 11, ["\12"] = 12, ["\13"] = 13, ["\14"] = 14, ["\15"] = 15, ["\16"] = 16, ["\17"] = 17, ["\18"] = 18, ["\19"] = 19, ["\20"] = 20, ["\21"] = 21, ["\22"] = 22, ["\23"] = 23, ["\24"] = 24, ["\25"] = 25, ["\26"] = 26, ["\27"] = 27, ["\28"] = 28, ["\29"] = 29, ["\30"] = 30, ["\31"] = 31, [" "] = 32, ["!"] = 33, ["\""] = 34, ["#"] = 35, ["$"] = 36, ["%"] = 37, ["&"] = 38, ["'"] = 39, ["("] = 40, [")"] = 41, ["*"] = 42, ["+"] = 43, [","] = 44, ["-"] = 45, ["."] = 46, ["/"] = 47, ["0"] = 48, ["1"] = 49, ["2"] = 50, ["3"] = 51, ["4"] = 52, ["5"] = 53, ["6"] = 54, ["7"] = 55, ["8"] = 56, ["9"] = 57, [":"] = 58, [";"] = 59, ["<"] = 60, ["="] = 61, [">"] = 62, ["?"] = 63, ["@"] = 64, A = 65, B = 66, C = 67, D = 68, E = 69, F = 70, G = 71, H = 72, I = 73, J = 74, K = 75, L = 76, M = 77, N = 78, O = 79, P = 80, Q = 81, R = 82, S = 83, T = 84, U = 85, V = 86, W = 87, X = 88, Y = 89, Z = 90, ["["] = 91, ["\\"] = 92, ["]"] = 93, ["^"] = 94, _ = 95, ["`"] = 96, a = 97, b = 98, c = 99, d = 100, e = 101, f = 102, g = 103, h = 104, i = 105, j = 106, k = 107, l = 108, m = 109, n = 110, o = 111, p = 112, q = 113, r = 114, s = 115, t = 116, u = 117, v = 118, w = 119, x = 120, y = 121, z = 122, ["{"] = 123, ["|"] = 124, ["}"] = 125, ["~"] = 126, ["\127"] = 127, ["\128"] = 128, ["\129"] = 129, ["\130"] = 130, ["\131"] = 131, ["\132"] = 132, ["\133"] = 133, ["\134"] = 134, ["\135"] = 135, ["\136"] = 136, ["\137"] = 137, ["\138"] = 138, ["\139"] = 139, ["\140"] = 140, ["\141"] = 141, ["\142"] = 142, ["\143"] = 143, ["\144"] = 144, ["\145"] = 145, ["\146"] = 146, ["\147"] = 147, ["\148"] = 148, ["\149"] = 149, ["\150"] = 150, ["\151"] = 151, ["\152"] = 152, ["\153"] = 153, ["\154"] = 154, ["\155"] = 155, ["\156"] = 156, ["\157"] = 157, ["\158"] = 158, ["\159"] = 159, ["\160"] = 160, ["\161"] = 161, ["\162"] = 162, ["\163"] = 163, ["\164"] = 164, ["\165"] = 165, ["\166"] = 166, ["\167"] = 167, ["\168"] = 168, ["\169"] = 169, ["\170"] = 170, ["\171"] = 171, ["\172"] = 172, ["\173"] = 173, ["\174"] = 174, ["\175"] = 175, ["\176"] = 176, ["\177"] = 177, ["\178"] = 178, ["\179"] = 179, ["\180"] = 180, ["\181"] = 181, ["\182"] = 182, ["\183"] = 183, ["\184"] = 184, ["\185"] = 185, ["\186"] = 186, ["\187"] = 187, ["\188"] = 188, ["\189"] = 189, ["\190"] = 190, ["\191"] = 191, ["\192"] = 192, ["\193"] = 193, ["\194"] = 194, ["\195"] = 195, ["\196"] = 196, ["\197"] = 197, ["\198"] = 198, ["\199"] = 199, ["\200"] = 200, ["\201"] = 201, ["\202"] = 202, ["\203"] = 203, ["\204"] = 204, ["\205"] = 205, ["\206"] = 206, ["\207"] = 207, ["\208"] = 208, ["\209"] = 209, ["\210"] = 210, ["\211"] = 211, ["\212"] = 212, ["\213"] = 213, ["\214"] = 214, ["\215"] = 215, ["\216"] = 216, ["\217"] = 217, ["\218"] = 218, ["\219"] = 219, ["\220"] = 220, ["\221"] = 221, ["\222"] = 222, ["\223"] = 223, ["\224"] = 224, ["\225"] = 225, ["\226"] = 226, ["\227"] = 227, ["\228"] = 228, ["\229"] = 229, ["\230"] = 230, ["\231"] = 231, ["\232"] = 232, ["\233"] = 233, ["\234"] = 234, ["\235"] = 235, ["\236"] = 236, ["\237"] = 237, ["\238"] = 238, ["\239"] = 239, ["\240"] = 240, ["\241"] = 241, ["\242"] = 242, ["\243"] = 243, ["\244"] = 244, ["\245"] = 245, ["\246"] = 246, ["\247"] = 247, ["\248"] = 248, ["\249"] = 249, ["\250"] = 250, ["\251"] = 251, ["\252"] = 252, ["\253"] = 253, ["\254"] = 254, ["\255"] = 255},
		char = {"\1", "\2", "\3", "\4", "\5", "\6", "\7", "\8", "\9", "\n", "\11", "\12", "\13", "\14", "\15", "\16", "\17", "\18", "\19", "\20", "\21", "\22", "\23", "\24", "\25", "\26", "\27", "\28", "\29", "\30", "\31", " ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "\127", "\128", "\129", "\130", "\131", "\132", "\133", "\134", "\135", "\136", "\137", "\138", "\139", "\140", "\141", "\142", "\143", "\144", "\145", "\146", "\147", "\148", "\149", "\150", "\151", "\152", "\153", "\154", "\155", "\156", "\157", "\158", "\159", "\160", "\161", "\162", "\163", "\164", "\165", "\166", "\167", "\168", "\169", "\170", "\171", "\172", "\173", "\174", "\175", "\176", "\177", "\178", "\179", "\180", "\181", "\182", "\183", "\184", "\185", "\186", "\187", "\188", "\189", "\190", "\191", "\192", "\193", "\194", "\195", "\196", "\197", "\198", "\199", "\200", "\201", "\202", "\203", "\204", "\205", "\206", "\207", "\208", "\209", "\210", "\211", "\212", "\213", "\214", "\215", "\216", "\217", "\218", "\219", "\220", "\221", "\222", "\223", "\224", "\225", "\226", "\227", "\228", "\229", "\230", "\231", "\232", "\233", "\234", "\235", "\236", "\237", "\238", "\239", "\240", "\241", "\242", "\243", "\244", "\245", "\246", "\247", "\248", "\249", "\250", "\251", "\252", "\253", "\254", "\255"; [0] = "\0"},
		cache = {},
		cache_size = 20,
	}

	function strsplit(s)
		s = s .. ''
		local cache = %env.cache
		if cache[s] then
			print('<color=black>CACHE ',s)
			cache[s].counter = 0
			return cache[s]
		else
			print('<color=black>NEW ',s)
			for s, t in cache do
				if t then
					t.counter = t.counter + 1
					if t.counter > %env.cache_size then
						print('<color=black>DELETE ',s)
						cache[s] = nil
					end
				end
			end
		end
		local t = {n = 0, counter = 0}
		cache[s] = t
		if s == '' then
			return t
		end
		local st = ''
		local char = %env.char
		local limit = %env.limit
		local n = 0
		while n < limit do
			local last
			local lastsymbol = '\0'
			local shift = 0
			local base = 256
			for i=1,8 do
				base = base * 0.5
				local sym = char[shift + base]
				local w = st .. sym
				if w <= s then
					shift = shift + base
					last = w
					lastsymbol = sym
				end
			end
			n = n + 1
			t[n] = lastsymbol
			st = last or st .. '\0'
			if st == s then break end
		end
		t.n = n
		return t
	end
	
	function strfind(s, search, start)
		start = start or 1
		local st = strsplit(s)
		local ft = strsplit(search)
		if start < 0 then
			start = st.n + start + 1
		end
		for i = start, st.n - ft.n + 1 do
			local fail
			for j = 1, ft.n do
				if st[i - 1 + j] ~= ft[j] then
					fail = 1
					break
				end
			end
			if not fail then
				return i
			end
		end
		return nil
	end
	
	function strsub(s, i, j)
		i = (i or 1) + 0
		j = (j or -1) + 0
		local st = strsplit(s)
		if i < 0 then i = st.n + i + 1 end
		if i < 1 then i = 1
		elseif i > st.n then i = st.n
		end
		if j < 0 then j = st.n + j + 1 end
		if j < 1 then j = 1
		elseif j > st.n then j = st.n
		end
		local r = concat(st, '', i, j)
		return r
	end
	
end

function pcall(func, _1, _2, _3, _4, _5, _6, _7, _8, _9)
	local t = {-1}
	startThread(function()
		local t = %t
		errorHook(function() %t[1] = 0 end)
		t[2] = pack(%func(%_1, %_2, %_3, %_4, %_5, %_6, %_7, %_8, %_9))
		t[1] = 1
	end)
	while t[1] == -1 do
		sleep()
	end
	if t[1] == 1 then
		return 1, t[2]
	else
		return nil
	end
end

function pack(...)
	return arg
end

function getn(t)
	if t.n then return t.n end
	local r = 1
	while t[r] do
		r = r * 2
	end
	local l = 0
	while r > 1 do
		r = r * 0.5
		if t[l + r] then
			l = l + r
		end
	end
	return l
end

function append(t, v)
	local len = getn(t)
	t[len + 1] = v
	t.n = len + 1
end

function extend(t, ...)
	t = t or {}
	local r = getn(t)
	for i = 1, arg.n do
		local u = arg[i]
		if u then
			local n = getn(u)
			for j = (u[0] and 0 or 1), n do
				r = r + 1
				t[r] = u[j]
			end
		end
	end
	return t
end

function concat(t, sep, i, j)
	i = i or 1
	j = j or getn(t)
	sep = sep or ''
	local n = j - i + 1
	local u = {}
	for k = 1, n do
		u[k] = t[k + i - 1]
	end
	local step = 1
	while step < n do
		for k = 1, n, step * 2 do
			local l = k + step
			if u[l] then
				u[k] = u[k] .. sep .. u[l]
				u[l] = ''
			end
		end
		step = step * 2
	end
	return u[1] or ''
end

function index(t, v)
	for k, e in t do
		if e == v then
			return k
		end
	end
	return nil
end

function sum(t)
	local s = 0
	for i = 1, getn(t) do
		s = s + t[i]
	end
	return s
end

do
	local env = {}
	env.incs = {n=16; 1391376, 463792, 198768, 86961, 33936, 13776, 4592, 1968, 861, 336, 112, 48, 21, 7, 3, 1}

	function env.lt(a, b)
		return a < b
	end
	
	function env.bg(a, b)
		return a > b
	end

	function env.sort(t, n, before)
		for a=1,%env.incs.n do
			local h = %env.incs[a]
			local i = h + 1
			while i <= n do
				local v = t[i]
				for j = i - h, 1, -h do
					local testval = t[j]
					if not before(v, testval) then break end
					t[i] = testval
					i = j
				end
				t[i] = v
				i = i + 1
			end
		end
		return t
	end

	function sort(t, before, n)
		n = n or getn(t)
		if not before or before == "<" then before = %env.lt
		elseif before == ">" then before = %env.bg
		end
		%env.sort(t, n, before)
		return t
	end

end