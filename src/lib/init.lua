
-- make sure dll is 'fresh'
--os.execute("if test -f /src/lib/bypass.dll; then rm src/lib/bypass.dll; fi")
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
  char* input_buf();
  long getns();
  int curs_set(int mode);
  int testmath();
]]
local dll = ffi.load("src/lib/bypass.dll")
print(dll.testmath())

FGCOLOR = {255,255,255}
BGCOLOR = {0,0,0}
fr,fg,fb = unpack(FGCOLOR) -- mutable global variables to reduce memory usage in functions
br,bg,bb = unpack(BGCOLOR)
function slp(duration)
  --os.execute(conc("tcc -run src/lib/sleep.c ","\"",duration,"\""))
  duration = duration or 0.5
  dll.sleep_s(duration)
  --(os.execute can have significant overhead)
end
function input_buf() return dll.input_buf() end
function rgbwr(text,rgb)
  fr = flr((255*btoi[rgb[1]>255])+(0*btoi[rgb[1]<0])+(rgb[1]*btoi[256 > rgb[1] and rgb[1] >= 0]))
  fg = flr((255*btoi[rgb[2]>255])+(0*btoi[rgb[2]<0])+(rgb[2]*btoi[256 > rgb[2] and rgb[2] >= 0]))
  fb = flr((255*btoi[rgb[3]>255])+(0*btoi[rgb[3]<0])+(rgb[3]*btoi[256 > rgb[3] and rgb[3] >= 0]))
  io.write(
    conc("\027[38;2;",fr,";",fg,";",fb,"m",text)
  )
end
function rgbbg(rgb)
  br = flr((255*btoi[rgb[1]>255])+(0*btoi[rgb[1]<0])+(rgb[1]*btoi[256 > rgb[1] and rgb[1] >= 0]))
  bg = flr((255*btoi[rgb[2]>255])+(0*btoi[rgb[2]<0])+(rgb[2]*btoi[256 > rgb[2] and rgb[2] >= 0]))
  bb = flr((255*btoi[rgb[3]>255])+(0*btoi[rgb[3]<0])+(rgb[3]*btoi[256 > rgb[3] and rgb[3] >= 0]))
  io.write(
    conc("\027[48;2;",br,";",bg,";",bb,"m")
  )
end
function rgbset(rgb,BGrgb)
  FGCOLOR = rgb
  BGCOLOR = BGrgb or BGCOLOR
  rgbwr("",rgb)
  rgbbg(BGrgb)
end
function rgbreset()
  rgbwr("",FGCOLOR)
  rgbbg(BGCOLOR)
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
-- function setcursor(mode)
--   -- takes 0 (hidden), 1 (visible), or 2 ("extra visible")
--   -- https://invisible-island.net/ncurses/man/curs_kernel.3x.html
--   -- refer to part about the curs_set routine
--   mode = mode or dll.curs_set(1)
--   return dll.curs_set(mode)
-- end

maxnum = 2^(53)-(2^8)
math.randomseed(maxnum-os.time())
btoi={[true]=1,[false]=0}; -- boolean to integer
gc={[true]=load([[collectgarbage("collect");
    collectgarbage("collect")]]),
      [false]=load("return ;")} -- stands for 'g.arbage c.ollect'
SPACE = " "
BLOCK = {"▄","▀","█"} --alt codes 220,223,219 resp.
mobile_irl = 0 -- really should just get rid of this...
mobile_scale = (0.8*(btoi[not mobile_irl==0]))+1*btoi[mobile_irl==0] --placeholder estimate
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

flags = {"-sane"}
reverse_flags = table.concat(swapflags(flags)," ");
flags = table.concat(flags," ")
-- os.execute("stty "..flags) -- put TTY in raw mode

keymaps = dofile("src/lib/keymap.lua")
SCREEN = {}
SCREEN[1] = initscreen(WIDTH,HEIGHT)
mainbuf = SCREEN[1]
-- statsbuf = ... ; (etc.)


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
  clrline()
  print("((Feature not yet implemented.))")
end
checkdeadline={[true]=load("breakwait = true;"),
    [false]=load("return ;")}
breakwait = false
function busywait(starttime,duration)
  local deadline = starttime+duration
  while breakwait==false do
      checkdeadline[os.clock() >= (deadline)]()
  end
  breakwait = false
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
