function flrall(t)
	local flr = math.floor
	local tmp = t
    for i=1,#tmp do
        tmp[i] = flr(tmp[i])
    end
    return tmp
end
numtable = {}
for i=1,25 do
	numtable[i] = (i*1.3)
end
for i=1,#numtable do
	io.write(numtable[i]);io.write(" ")
end
print()
local newnums = flrall(numtable)
for i=1,#newnums do
	io.write(table.concat({tostring(newnums[i])," "}))
end