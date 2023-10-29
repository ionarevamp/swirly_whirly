function testcodes() --KEEP THIS FUNCTION FOR LATER TESTING
  local limit = 80
  for i=1,limit do
    for j=i,limit do
      io.write("\27["..37+i..";2;"..math.floor(255/j)..";100;100mX \27[0m")
    end
    print()
  end
end

os.execute("if test -f src/lib/bypass.dll; then rm src/lib/bypass.dll; fi")
-- declare universal structs before mass require-ing

function flr(...) return math.floor(...) end
function flrall(arr)
        local tmp = {}
  for i=1,#tmp do tmp[i] = flr(tmp[i]) end
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
  int getms();
]]
local prefixdir = tostring(io.popen("echo $PREFIX"):read())
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
function rgbset(rgb)
  FGCOLOR = rgb
  rgbwr("",FGCOLOR)
end
function rgbbg(rgb)
  BGCOLOR = rgb
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
  rgbreset()
  io.flush()
end
function getms() return dll.getms() end

maxnum = 2^(53)-(2^8)
math.randomseed(maxnum-os.time())
bc={[true]=1,[false]=0}; -- stands for 'b.ool c.heck'
gc={[true]=load([[collectgarbage("collect");
    collectgarbage("collect")]]),
      [false]=load("return ;")} -- stands for 'g.arbage c.ollect'
SPACE = " "
BLOCK = {"▄","▀","█"} --alt codes 220,223,219 resp.
debug = 1
HEIGHT = (io.popen('tput lines'):read() or 24) - 1
WIDTH = tonumber(io.popen('tput cols'):read() or 80)
CENTER = {flr(HEIGHT/2),flr(WIDTH/2)}
ASPECTRATIO = WIDTH/HEIGHT
ratio = ASPECTRATIO
invratio = 1/ASPECTRATIO
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
  local dbgmsg = "KB in RAM: "
  local screensize = conc("h: ",HEIGHT," w: ",WIDTH," | ")
  mcu();mcr(WIDTH-(#screensize+#dbgmsg+#kbmem))
  io.write(conc(screensize,dbgmsg,kbmem))
  print()
end

function draw_circle(cx,cy,size)
  local HEIGHT = HEIGHT
  local sqrt = math.sqrt
  local flr = math.floor
  local ceil = math.ceil
  local sin = math.sin
  local cos = math.cos
  local pi = math.pi
  local degrange = 2*pi
  size = size or 5
  size = size-1
  radius = size/2
  local x,y = 0,0
  cx = cx or CENTER[2]
  cy = cy or CENTER[1]
  local dir = 1
  for i=0,degrange,(degrange/360)+y do
    x = ceil(radius*cos(i))
    y = ceil(radius*sin(i)*0.35)
    -- Y val adjusted for monospace dimensions (roughly)
    mvcursor(cx+x,cy+y)
    rgbwr("0",CLR.gold)
  end
  io.flush()
end

function pulse_fill(state,opacity,speed,rgb,background,dir)
  background = background or CLR.black
  state = state or 1
  rgb = rgb or BGCOLOR
  opacity = opacity or 100
  local opacity = opacity/100
  speed = speed or 1
  dir = dir or 1
  local HEIGHT = HEIGHT - 1
  local sin = math.sin
  local cos = math.cos
  local color = gradient(rgb,background,opacity)
  rgbbg(color)
  local r,g,b = unpack(rgb)
  for i=1,HEIGHT do
    local wave = sin((speed*i/10)+state)*opacity
    color = gradient(rgb,background,wave)
    rgbbg(color)
    for j=1,WIDTH do
      io.write(" ")
    end
  io.flush()
  end
end

for i=0,HEIGHT do
  print()
end

os.execute("tput civis")
local circle_size = 1
local start_time = os.clock()
local radius = (circle_size/2)
for xpos=12,19,0.1 do
  clr()
  draw_circle(xpos,CENTER[1]-flr(radius/2),circle_size+xpos)
end
mvcursor(1,HEIGHT-radius/2)
print()
local end_time = os.clock()
print("Time taken: ",end_time-start_time,conc("H: ",HEIGHT," W: ",WIDTH));slp(1)

collectgarbage("stop")
local interval = 300
local loopstart = getms()
for st=0,100,1 do
  local deadline = (st*interval)
  totop()
  pulse_fill(st,50,2,CLR.royalblue,CLR.black)
  memcount()
  collectgarbage("collect")
  for i=0,5000 do 
    if getms() >= deadline+loopstart then
      break;
    end
    slp(0.0001)
  end
end
collectgarbage("collect");

os.execute("tput cnorm")
os.exit()
