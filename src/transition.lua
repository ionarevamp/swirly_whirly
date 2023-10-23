
print()
c_align()
local squiggleportion = 2*flr(WIDTH/5)
local introcolors = {CLR.gray0,CLR.gray1,CLR.silver}
for r = 1,3 do
local limit = squiggleportion+(r*4)
for ri = 1,limit do
    local dir = (ri-1) % 2
    local distance = (ri+dir-bc[(ri>1)])-1
    rgbwr("~",introcolors[r])
    io.flush();slp(0.7/limit);
    if dir == 0 then
        mcl(distance+bc[(ri>1)])
    else 
        mcr(distance-(ri/distance))
    end
end
io.flush()
print()
c_align()
io.flush()
slp(0.3/r)
end