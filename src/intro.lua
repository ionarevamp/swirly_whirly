function splash_intro(noise,duration,mode)
-- NOISE: too much noise is bad, no noise is worse when using randchar()
    local HEIGHT = HEIGHT-10
    local delay = duration/HEIGHT
    local center = HEIGHT/2
    local ratio = HEIGHT/WIDTH
    local exit = false
    local starttime = os.clock()
    for j = 1, HEIGHT do
        for i = 1, WIDTH do
            local ratio = HEIGHT/WIDTH
            local rando = (math.random()-0.5)*noise
            local colordiff = (btoi[j<center]*(12*mode)*(j/center))+(
                            btoi[j>center]*(12*mode)*(center/j))
            if j == flr(ratio*i+((noise*(mode-1))+rando*(HEIGHT-j*2))) or
            j == flr(HEIGHT-(ratio*i+rando*(HEIGHT-j*2))) then
                tobuffer(i,j,randchar(),
                {101+(25*mode)+colordiff,colordiff,colordiff},
                BGCOLOR)
            else tobuffer(i,j,"",FGCOLOR,BGCOLOR)
            end
        end
        printlinebuf(j)
        --if exit then break end
        io.flush();io.write("\n");
        busywait(starttime,delay*(j+math.sin(j)))
    end

end
clr();
clearbuff();
print(conc("h: ",HEIGHT,", w: ",WIDTH))
-- INTRO SCREEN
os.execute("tput civis")-- setcursor(0)
print("intro print test 1")
splash_intro(0.40,1.5,1.2) -- Good noise value, but may be shifted by < 0.1
print("intro print test 2")
mvcursor(2,4)
splash_intro(0.30,1.5,2)
os.execute("tput cnorm")-- setcursor(1)
slp(0.6)
  -- TRANSITION
print();rgbreset();

local decidedir = {"return ;","mcl(2)"}
local squiggleportion = (2*flr(WIDTH/5))
local introcolors = {CLR.slategray,CLR.brightsilver}
local stamp = {{" "," "},{BLOCK[1],BLOCK[2]}}
for r = 1,3 do
    if r==2 then mcr(WIDTH) end
    local limit = squiggleportion+(r*4)
    local startpos = CENTER[2]-(limit/2)
    local m_abs = math.abs
    for ri = 1,(WIDTH-startpos) do
        local dir = btoi[(r % 2) == 0]
        local wavedir = btoi[(ri % 2) == 0]
        local poscheck = ri>=startpos and ri<=(WIDTH-startpos)
        local curcolor = gradientratio(
            introcolors[1],introcolors[2],
            m_abs(startpos-ri),WIDTH)
        rgbwr(stamp[btoi[poscheck]+1][wavedir+1],curcolor)
        load(decidedir[dir+1])()
        io.flush();slp((1/WIDTH)*btoi[poscheck]);
    end
    print()
    io.flush()
    slp(0.3/r)
end
-- TITLE CARD
splash_text = "BANDING"
checkdeadline={[true]=load("breakwait = true;"),
    [false]=load("return ;")}
c_align(splash_text)


-- NEEDS TWEAKING !!
-- loop does not calculate the correct amount of time,
--  presumably due to rounding errors
interval = 0
loopstart = 0
breakwait = false
duration = 3
duration = duration*1.00000000000000000
writestart = os.clock()
for i = 1,#splash_text do
    blendlimit = 50
    increment = 100/blendlimit
    loopstart = os.clock()
    for st=1,100,increment do
        deadline = ((st*i)*duration/(100*#splash_text))
                    +writestart
        rgbbg(gradientratio(
            CLR.red,BGCOLOR,st,100,-1))
        rgbwr(charat(splash_text,i),gradientratio(--
            CLR.goldmetal,CLR.gold,i,#splash_text))
        io.flush()
        rgbreset()
        breakwait = false
        while breakwait==false do
            checkdeadline[os.clock() >= (deadline)]()
        end
        
        mcl()
    end
    rgbreset()
    mcr()
end
print("\n","Finished in",os.clock()-writestart)
slp(0.7)

--- test area


  
  

--- test area





rgbreset()
print()