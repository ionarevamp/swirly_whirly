--[[
flags = {"icanon","-tostop"}
reverse_flags = table.concat(swapflags(flags)," ");
flags = table.concat(flags," ")
os.execute("stty "..flags) -- put TTY in raw mode
]] -- legacy. not sure if it will really even be needed.

-- make sure dll is 'fresh'
os.execute("if test -f /src/lib/bypass.dll; then rm src/lib/bypass.dll; fi")
-- declare universal structs before mass require-ing

function flr(...) return math.floor(...) end
function flrall(arr)
  local tmp = {}
  for i=1,#tmp do tmp[i] = flr(arr[i]) end
  return tmp
end
function gmch(...) return string.gmatch(...) end
function conc(...) --table.concat for speed(?)
  local args = {...}
  return table.concat(args)
end;
-- COMPILE/BUILD
dofile("src/build.spec")
local ffi=require("ffi")
ffi.cdef[[
  void sleep_s(float duration);
  void rgbwr(const char* text,float r,float g,float b);
  void rgbbg(float r,float g,float b);
  void rgbreset(float Rr,float Rg,float Rb,float Br,float Bg,float Bb);
  char* input_buf();
  void Cwrite(const char* text);
  long getns();
]]
local dll = ffi.load("src/lib/bypass.dll")

FGCOLOR = {255,255,255}
BGCOLOR = {0,0,0}
function slp(duration)
  --os.execute(conc("tcc -run src/lib/sleep.c ","\"",duration,"\""))
  duration = duration or 0.5
  dll.sleep_s(duration)
  --(os.execute can have significant overhead)
end
function printf(text) return dll.Cwrite(text) end
function input_buf() return dll.input_buf() end
function rgbreset()
  Rr,Rg,Rb = unpack(FGCOLOR)
  Br,Bg,Bb = unpack(BGCOLOR)
  dll.rgbreset(Rr,Rg,Rb,Br,Bg,Bb);
  io.flush()
end
function rgbwr(text,rgb)
  local r,g,b = unpack(rgb)
  --^^cannot simply pass a list to C
  -- (scalar-ize data?)
  dll.rgbwr(text,r,g,b)
end
function rgbset(rgb,BGrgb)
  FGCOLOR = rgb
  BGrgb = BGrgb or BGCOLOR
  rgbwr("",FGCOLOR)
  rgbbg(BGrgb)
end
function rgbbg(rgb)
  local r,g,b = unpack(rgb)
  dll.rgbbg(r,g,b)
end
function rgbprint(text,bgrgb,fgrgb)
  rgbbg(bgrgb) -- set background
  rgbwr(text,fgrgb) -- set foreground
  rgbreset() -- reset terminal color
  print()
  io.flush()
end
function rgbline(text,bgrgb,fgrgb)
  rgbbg(bgrgb)
  rgbwr(text,fgrgb)
  for i=1,WIDTH-#text do
    io.write(" ") --fill bg before newline
  end
  rgbreset()
  print()
  io.flush()
end
function gameprompt(string,bgrgb,fgrgb)
  rgbline(string,bgrgb,fgrgb)
  for i=1,WIDTH-#string do
    io.write(" ")
  end
  clrline()
  io.flush()
end
function getms() return tonumber(dll.getns()) end

maxnum = 2^(53)-(2^8)
math.randomseed(maxnum-os.time())
bc={[true]=1,[false]=0}; -- stands for 'b.ool c.heck'
gc={[true]=load([[collectgarbage("collect");
    collectgarbage("collect")]]),
      [false]=load("return ;")} -- stands for 'g.arbage c.ollect'
SPACE = " "
BLOCK = {"▄","▀","█"} --alt codes 220,223,219 resp.
debug = 1
mobile_irl = 0 -- really should just get rid of this...
mobile_scale = (0.8*(bc[not mobile_irl==0]))+1*bc[mobile_irl==0] --placeholder estimate
HEIGHT = (io.popen('tput lines'):read() or 24) - 1
WIDTH = tonumber(io.popen('tput cols'):read() or 80)
CENTER = {flr(HEIGHT/2),flr(WIDTH/2)}
MEMLIMIT = (262144*0.9) - tonumber(
  string.match(io.popen('grep MemTotal /proc/meminfo'):read(),
  "%d+"))
quit = 0
cur_input = ""
cmd = {}
cmd_lower = ""

local modules = {"buffer","strings","stats",
                 "colors","gfx","menu",
                 "commands"}
for i=1,#modules do
  require("src/lib/"..modules[i])
end
local map = dofile("src/lib/keymap.lua")

function memcount() 
  local kbmem = string.match(collectgarbage("count"),"%d+%.?%d*")
  kbmem = tostring(flr((kbmem*1000))/1000)
  local dbgmsg = "KB in RAM: "
  local screensize = conc("h: ",HEIGHT," w: ",WIDTH," | ")
  mcu();mcr(WIDTH-(#screensize+#dbgmsg+#kbmem))
  io.write(conc(screensize,dbgmsg,kbmem))
  print()
end
function blankerr()
  print("((Feature not yet implemented.))")
end
function draw_x(size, location, angle, height, noise)
  -- NOISE: too much noise is bad, no noise is worse when using randchar()
  --TODO: fix this function to use all parameters properly

  local startX = location[1] - flr(size / 2)
  local startY = location[2] - flr(height / 2)

  for j = 1, height do
    for i = 1, size do
      local rando = math.random()-0.5*noise
      local easex = math.abs((size/2)-i)/2
      local easey = math.abs((height/2)-j)/2
      if j == flr(height/size*i+(rando)) or j == flr(height- ((height/size)*i+(rando))) then
        prc()
      else
        io.write(SPACE)
      end
    end
    io.write("\n")
  end
end

rgbwr("FUNCTIONS LOADED\n",{140,120,100})
--Reminder: use unpack on rgb table call from color list

memcount();slp(0.5)
function main()
  for i=0,HEIGHT do io.write() end
  clr()  
  --dofile("src/intro.lua")
  c_print("Press Enter key to start",CENTER[2])
  memcount()
  mcr(CENTER[2]);io.flush();  
  local foo = io.read()
  io.write(conc("\027[2J\027[1;1H","Debug msg: Preparing...\n"))
  slp()
  
  -- START MENU
  -- startmenu:open()
  -- while startmenu.state ~= 0 do
  --     print("Start menu reached.")
  --     for i=1,1000 do
  --       rgbwr("X",{i*(255/1000),0,0})
  --       io.flush()
  --     end
  --     slp();startmenu:close()
  -- end
  -- local monsterload = "rat"
  -- buffer_file(conc("src/mons/",monsterload,".txt"))
  -- update()

  -- MAIN LOOP --  --  -- MAIN LOOP --
  local input_buf = {}
  clr()
  rgbreset()
  
  while (quit == 0) do
    pcall(gc[collectgarbage("count") > MEMLIMIT])
    -- handle displaying stuff
    rgbreset()
    gameprompt("What would you like to do?",
      CLR.darkgray,
      {200,180,180})
    memcount()
    cur_input = io.read()
    for word in gmch(cur_input,"%S+") do
      table.insert(cmd,word)
    end
    cmd[1] = checkcmd(cmd[1])
    pcall(load(CMDS[cmd[1]])) -- refers to CMDS table, commands.lua
    cmd = {}
  end
end
main()
memcount()
--print("Reached end. Reverse flag table: "..reverse_flags);
--print(conc(startmenu.state,charskills.state,itemui.state))
--os.execute("stty "..reverse_flags) -- at end of program, put TTY back to normal mode

