chkey = package.loadlib("src/keystate.dll", "IsKeyPressed")
if chkey then
    msg1=("DLL loaded successfully")
else
   msg1=("Error loading DLL")
end

math.randomseed(os.time())
bc={ [true]=1, [false]=0 } -- allows bool-to-num

function slp(duration)
  os.execute("sleep "..duration)
end

function conc(...)
  local args = {...}
  return table.concat(args)
end

-- CURSOR MOVEMENT
function mvcursor(x,y) -- Non-relative cursor position starting at 1,1
  io.write(conc("\027[",x,";",y,"H"))
end
function mcr(distance) -- M.ove C.ursor. R.ight
  distance = distance or 1
  io.write(conc("\027[",distance,"C"))
end
function mcl(distance) -- left
  distance = distance or 1
  io.write(conc("\027[",distance,"D"))
end
function mcu(distance) -- up
  distance = distance or 1
  io.write(conc("\027[",distance,"A"))
end
function mcd(distance) -- down
  distance = distance or 1
  io.write(conc("\027[",distance,"B"))
end
function totop(distance)
  mvcursor(1,1)
end
function clr()
  io.write("\027[2J\027[1;1H")
end
function clrline()
  io.write("\027[2K\027[1G")
end

-- RANDOMNESS
function randchar()
  local randnum = math.random()
  return string.char(math.floor(32.3 + (randnum * 94)))
end
function prc()
  io.write(randchar())
end
function prcln()
  print(randchar())
end

-- ALIGN TEXT
function c_align(string,center)
  for blank = 0,math.ceil(center-(#string/2)) do
    io.write(" ")
  end
end
function c_write(string,center)
  c_align(string,center)
  io.write(string)
end
function c_print(string,center)
  c_write(conc(string,"\n"),center)
end

  

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

function splash_intro(height, width, noise, delay)
  -- NOISE: too much noise is bad, no noise is worse when using randchar()
  
  for j = 1, height do
    for i = 1, width do
      local ratio = height/width
      local rando = (math.random()-0.5)*noise
      if j == math.floor(ratio*i+(rando*(height-j*2))) or j == math.floor(height- (ratio*i+(rando*(height-j*2)))) then
        prc()
      else
        mcr()
      end
    end
    io.write("\n");io.flush();
    slp(delay)
  end
end

function main()
  
  local debug = 1
  local mobile_irl = 0 -- `bc[device == smartphone]` ?
  local mobile_scale = (0.8*(bc[not mobile_irl==0]))+1*bc[mobile_irl==0] --placeholder estimate
  
  local HEIGHT = math.floor(((io.popen('tput lines'):read() or 24) - 1) * ((mobile_scale/ (mobile_irl+1)) or 1))
  local WIDTH = io.popen('tput cols'):read() or 80
  local CENTER = { math.ceil(HEIGHT / 2), math.ceil(WIDTH / 2) }
  
  local caps = {}
  local smalls = {}
  for letter=65, 90 do
    table.insert(caps, string.char(letter))
    table.insert(smalls, string.char(letter + 32))
  end
  local kc_esc = "0x01B" -- equivalent to 
  local kc_alpha = {}
  local hex_digits = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
  local tens = 5
  local ones = 2
  for alpha=1,26 do -- basically an inline decimal-to-hex convertor
    kc_alpha[alpha] = conc("0x",hex_digits[tens],hex_digits[ones])
    local overflow = bc[ones >= 16]
    tens = (tens+(1*overflow))-(16*bc[tens >= 16])
    ones = (ones+1)-(16*overflow)
  end

  clr();
  print(conc("h: ",HEIGHT,", w: ",WIDTH))
  
  -- INTRO SCREEN
  splash_intro(HEIGHT,WIDTH,0.30,0,0.02) -- Good noise value, but may be shifted by an amount < 0.1
  slp(0.005)
  totop()
  splash_intro(HEIGHT,WIDTH,0.30,0.18)
  slp(0.6)

  -- TRANSITION
  local transition_text = {"~~~~~~~~~~~~~~~~~~~~",
                            "~\\~~~~~~~~~~~~~~~~~~~~/~",
                            "~\\~\\~~~~~~~~~~~~~~~~~~~~/~/~"}

  for r = 1,3 do
    --c_print(transition_text[r],CENTER[2])
    c_align(transition_text[r],CENTER[2])
    for ri = 1,#transition_text[r] do
      local dir = (ri-1) % 2
      local distance = (ri)+dir
      local position = math.floor((#transition_text[r]/2)+distance+(-1*dir*distance*2))
      io.write(string.sub(transition_text[r],position,position));io.flush();slp(0.6)
      if dir == 0 then
        mcl(distance)
      else 
        mcr(distance)
      end

    end
    io.flush()
    slp(3.6-r)
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
  io.read()
  io.write(conc("\027[2J\027[1;1H","Debug msg: Preparing...\n"))
  slp(1)
  
  local input_buf = {}
  local quit = true
  
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
print("Reached end");
os.exit();