-- make sure dll is 'fresh'
os.execute("if test -f /src/lib/bypass.dll; then rm src/lib/bypass.dll; fi")
-- declare universal structs before mass require-ing
quit = 0
cur_input = ""
cmd = {}
bc={[true]=1,[false]=0}; -- stands for 'b.ool c.heck'
function flr(...) return math.floor(...) end
function flrall(arr)
	local tmp = arr
  for i=1,#tmp do tmp[i] = flr(tmp[i]) end
  return tmp
end
function gmch(...) return string.gmatch(...) end
function conc(...) --table.concat for speed(?)
  local args = {...}
  return table.concat(args)
end;
dofile("src/build.spec") -- COMPILE/BUILD
local ffi=require("ffi")
ffi.cdef[[
  void sleep_s(float duration);
  void rgbwr(const char* string,float r,float g,float b);
  void rgbbg(float r,float g,float b);
  void rgbreset();
  char* input_buf();
]]
local dll = ffi.load("src/lib/bypass.dll")

function slp(duration)
  --os.execute(conc("tcc -run src/lib/sleep.c ","\"",duration,"\""))
  dll.sleep_s(duration) -- 1 POINT zero (float)
  --(os.execute can have significant overhead)
end
function rgbwr(string,rgb)
  local r,g,b = unpack(rgb)
  --^^cannot simply pass a list to C
  dll.rgbwr(string,r,g,b)
end
function rgbbg(rgb)
  local r,g,b = unpack(rgb)
  dll.rgbbg(r,g,b)
end
function rgbreset() dll.rgbreset() end
rgbwr("FUNCTIONS LOADED\n",{140,120,100})
--Reminder: use unpack on rgb table call from color list

SPACE = " "
BLOCK = {"▄","▀","█"} --alt codes 220,223,219 resp.
debug = 1
mobile_irl = 0 -- really should just get rid of this...
mobile_scale = (0.8*(bc[not mobile_irl==0]))+1*bc[mobile_irl==0] --placeholder estimate
HEIGHT = (io.popen('tput lines'):read() or 24) - 1
WIDTH = tonumber(io.popen('tput cols'):read() or 80)
CENTER = {flr(HEIGHT/2),flr(WIDTH/2)}

local modules = {"buffer","strings","stats",
                 "colors","menu","commands"}
for i=1,#modules do
  require("src/lib/"..modules[i])
end
local map = dofile("src/lib/keymap.lua")
maxnum = 2^(53)-(2^8)
math.randomseed(maxnum-os.time())

--[[
flags = {"icanon","-tostop"}
reverse_flags = table.concat(swapflags(flags)," ");
flags = table.concat(flags," ")
os.execute("stty "..flags) -- put TTY in raw mode
]] -- legacy. not sure if it will really even be needed.

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

print(collectgarbage("count"));slp(0.5)
function main()
  
  --dofile("src/intro.lua")
  print(collectgarbage("count"))

  c_print("Press Enter key to start",CENTER[2])
  mcr(CENTER[2]);io.flush();  
  local foo = io.read()
  io.write(conc("\027[2J\027[1;1H","Debug msg: Preparing...\n"))
  slp(1)
  
  -- START MENU
  startmenu:open()
  while startmenu.state ~= 0 do
      print("Start menu reached.")
      for i=1,1000 do
        rgbwr("X",{i*(255/1000),0,0})
        io.flush()
      end
      slp(0.5);startmenu:close()
  end
  local monsterload = "rat"
  -- buffer_file(conc("src/mons/",monsterload,".txt"))
  -- update()

  -- MAIN LOOP --  --  -- MAIN LOOP --
  local input_buf = {}
  clr();collectgarbage("collect");
  while (quit == 0) do
    -- handle displaying stuff
    print(collectgarbage("count"));slp(0.3)
    rgbwr("What would you like to do? \n",{200,180,180})
    rgbreset()
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
print(collectgarbage("count"));slp(1)
--print("Reached end. Reverse flag table: "..reverse_flags);
print(conc(startmenu.state,charskills.state,itemui.state))
--os.execute("stty "..reverse_flags) -- at end of program, put TTY back to normal mode

