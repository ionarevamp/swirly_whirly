function splash_intro(noise,duration,mode)
-- NOISE: too much noise is bad, no noise is worse when using randchar()
local HEIGHT = HEIGHT-10
local delay = duration/HEIGHT
local center = HEIGHT/2
local ratio = HEIGHT/WIDTH
local exit = false

for j = 1, HEIGHT do
    for i = 1, WIDTH do
        local ratio = HEIGHT/WIDTH
        local rando = (math.random()-0.5)*noise
        local colordiff = (bc[j<center]*(12*mode)*(j/center))+(
                           bc[j>center]*(12*mode)*(center/j))
        if j == flr(ratio*i+((noise*(mode-1))+rando*(HEIGHT-j*2))) or
           j == flr(HEIGHT-(ratio*i+rando*(HEIGHT-j*2))) then
        rgbwr(randchar(),{101+(25*mode)+colordiff,colordiff,colordiff})
    else
        mcr()
    end
end
    if exit then break end
    io.write("\n");io.flush();
    slp(delay)
end
end
clr();
print(conc("h: ",HEIGHT,", w: ",WIDTH))
-- INTRO SCREEN
splash_intro(0.40,0.3,1.2) -- Good noise value, but may be shifted by < 0.1
mvcursor(2,4)
splash_intro(0.30,1.8,2)
slp(0.6)

  -- TRANSITION
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
