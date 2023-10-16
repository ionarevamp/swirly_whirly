-- declare universal structs before require-ing
bc={ [true]=1, [false]=0 }; -- stands for 'b.ool c.heck'
function conc(...) --table.concat for speed(?)
  local args = {...}
  return table.concat(args)
end;
function slp(duration) -- probably breaks on Windows
  os.execute(conc("sleep ",duration))
end

SPACE = " "
debug = 1
mobile_irl = 0 -- `bc[device == smartphone]` ?
mobile_scale = (0.8*(bc[not mobile_irl==0]))+1*bc[mobile_irl==0] --placeholder estimate
HEIGHT = math.floor(((io.popen('tput lines'):read() or 24) - 1) * ((mobile_scale/ (mobile_irl+1)) or 1))
WIDTH = io.popen('tput cols'):read() or 80
CENTER = { math.ceil(HEIGHT / 2), math.ceil(WIDTH / 2) }

local modules = {"buffer","strings","stats","menu"}
for i=1,#modules do
  require("src/lib/"..modules[i])
end

local map = dofile("src/lib/keymap.lua")
maxnum = 1.8*(10^308)
math.randomseed(maxnum-os.time()) --[[this method of
seeding isn't necessary, but it's kinda cool because
it progresses backwards through time]]

--[[
flags = {"icanon","-tostop"}
reverse_flags = table.concat(swapflags(flags)," ");
flags = table.concat(flags," ")
os.execute("stty "..flags) -- put TTY in raw mode
]]

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
        io.write(" ")
      end
    end
    io.write("\n")
  end
end

function splash_intro(noise, delay)
  -- NOISE: too much noise is bad, no noise is worse when using randchar()
  
  for j = 1, HEIGHT do
    local exit = false
    for i = 1, WIDTH do
      local ratio = HEIGHT/WIDTH
      local rando = (math.random()-0.5)*noise
      if j == math.floor(ratio*i+(rando*(HEIGHT-j*2))) or j == math.floor(HEIGHT- (ratio*i+(rando*(HEIGHT-j*2)))) then
        prc()
      else
        mcr()
      end
    end
    if exit then break end
    io.write("\n");io.flush();
    slp(delay)
  end
end

function main()
  clr();
  print(conc("h: ",HEIGHT,", w: ",WIDTH))
  
  -- INTRO SCREEN
  splash_intro(0.30,0,0.02) -- Good noise value, but may be shifted by an amount < 0.1
  slp(0.005)
  totop()
  splash_intro(0.30,0.08)
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
    slp((2+r)/(r*3))
  end


  -- TITLE CARD
  local splash_text = "BANDING"
  for rr = 1,#splash_text do
    clrline()
    c_align(splash_text,CENTER[2])
    io.write(string.sub(splash_text,1,rr))
    io.flush()
    slp(0.17)
  end
  
  print()
  c_print("Press Enter key to start",CENTER[2])
  mcr(CENTER[2]);io.flush();  
  io.read()
  io.write(conc("\027[2J\027[1;1H","Debug msg: Preparing...\n"))
  slp(1)
  
  local input_buf = {}
  local quit = true

  -- START MENU
  startmenu:open()
  while startmenu.state ~= 0 do
      print("Start menu reached.")
      slp(0.5);startmenu:close()
  end
  buffer_file("src/mons/rat.txt")
  update()

  -- MAIN LOOP --  --  -- MAIN LOOP --
  while not quit do
    clr()
    for db=0,5 do
      prc();
    end
    local input_str = "";
    for idx=1, #input_buf do
      local char = input_buf[idx]
      if char ~= "\n" and char ~= "\r" then
        input_str = input_str .. char
      end
    end
    quit = input_str == "quit"
    os.execute("sleep 0.1")
  end
  return 0
end

main()
--print("Reached end. Reverse flag table: "..reverse_flags);
print(conc(startmenu.state,charskills.state,itemui.state))
--os.execute("stty "..reverse_flags) -- at end of program, put TTY back to normal mode
os.exit();