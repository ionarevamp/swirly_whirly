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
        io.flush();io.write("\n");
        slp(delay)
    end
end
clr();
print(conc("h: ",HEIGHT,", w: ",WIDTH))
-- INTRO SCREEN
splash_intro(0.40,0.6,1.2) -- Good noise value, but may be shifted by < 0.1
mvcursor(2,4)
splash_intro(0.30,0.7,2)
slp(0.6)
  -- TRANSITION
print();rgbreset();

local decidedir = {";","mcl(2)"}
local squiggleportion = 2*flr(WIDTH/5)
local introcolors = {CLR.slategray,CLR.brightsilver}
local stamp = {{" "," "},{BLOCK[1],BLOCK[2]}}
for r = 1,3 do
    if r==2 then mcr(WIDTH) end
    local limit = squiggleportion+(r*4)
    local startpos = CENTER[2]-(limit/2)
    local m_abs = math.abs
    for ri = 1,(WIDTH-startpos) do
        local dir = bc[(r % 2) == 0]
        local wavedir = bc[(ri % 2) == 0]
        local poscheck = bc[ri>=startpos and ri<=(WIDTH-startpos)]+1
        local curcolor = gradientratio(
            introcolors[1],introcolors[2],
            m_abs(startpos-ri),WIDTH)
        rgbwr(stamp[poscheck][wavedir+1],curcolor)
        pcall(load(decidedir[dir+1]))
        io.flush();slp(1/WIDTH);
    end
    print()
    io.flush()
    slp(0.3/r)
end
-- TITLE CARD
splash_text = "BANDING"
checkdeadline={[true]=load("break ;"),
    [false]=load("slp(interval/100)")}
c_align(splash_text)
interval = 0;
loopstart = 0;
for i = 1,#splash_text do
    blendlimit = 1000
    interval = (1.21/i)/(blendlimit*4)
    for st=100,0,-100/blendlimit do
        loopstart = os.clock()
        rgbbg(gradientratio(
            BGCOLOR,CLR.red,st,-100))
        rgbwr(charat(splash_text,i),gradientratio(--
            CLR.goldmetal,CLR.gold,i,#splash_text))
        for j=0,100 do
            pcall(checkdeadline[
            os.clock()-loopstart >= interval])
        end
        rgbreset()
        io.flush()
        mcl()
    end
    mcr()
end


--- test area


  
  

--- test area





rgbreset()
print()