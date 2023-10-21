-- declare universal structs before mass require-ing
bc={ [true]=1, [false]=0 }; -- stands for 'b.ool c.heck'

function conc(...) --table.concat for speed(?)
  local args = {...}
  return table.concat(args)
end;
dofile("src/build.spec") -- COMPILE/BUILD
local ffi=require("ffi")
ffi.cdef[[
  void sleep_s(float duration);
  void rgbwr(const char* string,int r,int g,int b);
]]
local dll = ffi.load("src/lib/bypass.dll")
function slp(duration)
  --os.execute(conc("tcc -run src/lib/sleep.c ","\"",duration,"\""))
  dll.sleep_s(duration)
  --(os.execute can have significant overhead)
<<<<<<< HEAD
=======
end
function rgbwr(string,r,g,b)
  dll.rgbwr(string,r,g,b)
>>>>>>> refs/remotes/origin/master
end
function rgbwr(string,r,g,b)
  dll.rgbwr(string,r,g,b)
end
rgbwr("FUNCTIONS LOADED/n",unpack({140,120,100}))
--Reminder: use unpack on rgb table call from color list

SPACE = " "
debug = 1
mobile_irl = 0 -- really should just get rid of this...
mobile_scale = (0.8*(bc[not mobile_irl==0]))+1*bc[mobile_irl==0] --placeholder estimate
HEIGHT = math.floor(((io.popen('tput lines'):read() or 24) - 1) * ((mobile_scale/ (mobile_irl+1)) or 1))
WIDTH = io.popen('tput cols'):read() or 80
CENTER = { math.ceil(HEIGHT / 2), math.ceil(WIDTH / 2) }

local modules = {"buffer","strings","stats","menu","commands"}
for i=1,#modules do
  require("src/lib/"..modules[i])
end
local map = dofile("src/lib/keymap.lua")
maxnum = 5*(10^10)
math.randomseed(maxnum-os.time())

--[[
flags = {"icanon","-tostop"}
reverse_flags = table.concat(swapflags(flags)," ");
flags = table.concat(flags," ")
os.execute("stty "..flags) -- put TTY in raw mode
]] -- legacy. not sure if it will really even be needed.

function draw_x(size, location, angle, height, noise)
  -- NOISE: too much noise is bad, no noise is worse when using randchar()
  --TODO: fix this function to all parameters properly
  
  local startX = location[1] - math.floor(size / 2)
  local startY = location[2] - math.floor(height / 2)

  for j = 1, height do
    for i = 1, size do
      local rando = math.random()-0.5*noise
      local easex = math.abs((size/2)-i)/2
      local easey = math.abs((height/2)-j)/2
      if j == math.floor(height/size*i+(rando)) or j == math.floor(height- ((height/size)*i+(rando))) then
        prc()
      else
        io.write(SPACE)
      end
    end
    io.write("\n")
  end
end

<<<<<<< HEAD
function splash_intro(noise,duration,mode)
  -- NOISE: too much noise is bad, no noise is worse when using randchar()
  local HEIGHT = HEIGHT-10
  local delay = duration/HEIGHT
  local center = HEIGHT/2
  local ratio = HEIGHT/WIDTH
  local exit = false

=======
function splash_intro(noise, delay,mode)
  -- NOISE: too much noise is bad, no noise is worse when using randchar()
  local HEIGHT = HEIGHT-10
>>>>>>> refs/remotes/origin/master
  for j = 1, HEIGHT do
    for i = 1, WIDTH do
<<<<<<< HEAD
=======
      local ratio = HEIGHT/WIDTH
      local center = HEIGHT/2
>>>>>>> refs/remotes/origin/master
      local rando = (math.random()-0.5)*noise
      local colordiff = (bc[j<center]*(52*mode)*(j/center))+(
                         bc[j>center]*(52*mode)*(center/j))
      if j == math.floor(ratio*i+((noise*(mode-1))+rando*(HEIGHT-j*2))) or j == math.floor(HEIGHT-(ratio*i+rando*(HEIGHT-j*2))) then
        rgbwr(randchar(),101+(25*mode)+colordiff,colordiff,colordiff)
      else
        mcr()
      end
    end
    if exit then break end
    io.write("\n");io.flush();
  end
  slp(delay)
end

function main()
  clr();
  print(conc("h: ",HEIGHT,", w: ",WIDTH))
  -- INTRO SCREEN
<<<<<<< HEAD
  splash_intro(0.40,10,1.2) -- Good noise value, but may be shifted by < 0.1
  slp(0.005)
  mvcursor(2,3)
  splash_intro(0.30,30,2)
=======
  splash_intro(0.40,0,0.02,1.2) -- Good noise value, but may be shifted by an amount < 0.1
  slp(0.005)
  mvcursor(2,3)
  splash_intro(0.30,0.08,2)
>>>>>>> refs/remotes/origin/master
  slp(0.6)

  -- TRANSITION
  c_align();mcl();
  local squiggleportion = 2*math.floor(WIDTH/5)
  for r = 1,3 do
    local limit = squiggleportion+(r*4)
    for ri = 1,limit do
      local dir = (ri-1) % 2
      local distance = (ri+dir-bc[(ri>1)])-1
      io.write("~");io.flush();slp(0.5/limit);
      if dir == 0 then
        mcl(distance+bc[(ri>1)])
      else 
        mcr(distance-2)
      end
    end
    io.flush()
    print()
    c_align()
    io.flush()
    mcl()
    slp(0.3/r)
  end


  -- TITLE CARD
  local splash_text = "BANDING"
  for rr = 1,#splash_text do
    clrline()
    c_align(splash_text,CENTER[2]);mcr()
    io.write(string.sub(splash_text,1,rr))
    io.flush()
    slp(0.17)
  end
  
  print()
  c_print("Press Enter key to start",CENTER[2])
  mcr(CENTER[2]);io.flush();  
  local foo = io.read()
  io.write(conc("\027[2J\027[1;1H","Debug msg: Preparing...\n"))
  slp(1)
  
  -- START MENU
  startmenu:open()
  while startmenu.state ~= 0 do
      print("Start menu reached.")
      for i=1,5000 do
        rgbwr("X",i*(255/5000),i*(255/5000)/2,(30/i*2))
        io.flush()
      end
      slp(5)
      slp(0.5);startmenu:close()
  end
  local monsterload = "rat"
  -- buffer_file(conc("src/mons/",monsterload,".txt"))
  -- update()

  -- MAIN LOOP --  --  -- MAIN LOOP --
  local input_buf = {}
  local quit = 0
  clr()
  while (quit < 1) do
    -- handle displaying stuff
    rgbwr("What would you like to do? \n",200,180,180)
    local command = string.lower(io.read())
    load(CMDS[command])()
  end
end

main()
--print("Reached end. Reverse flag table: "..reverse_flags);
print(conc(startmenu.state,charskills.state,itemui.state))
--os.execute("stty "..reverse_flags) -- at end of program, put TTY back to normal mode
