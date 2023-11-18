
  function memcount()
    local kbmem = string.match(collectgarbage("count"),"%d+%.?%d*")
    local dbgmsg = "KB in RAM: "
    local screensize = conc("h: ",HEIGHT," w: ",WIDTH," | ")
    mcu();mcr(WIDTH-(#screensize+#dbgmsg+#kbmem+10))
    io.write(conc(screensize,dbgmsg,kbmem," Seconds elapsed: ",os.clock()))
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
    for i=0,degrange,(degrange/(360-y)) do
      x = ceil(radius*cos(i))
      y = ceil(radius*sin(i)*0.35)
      -- Y val adjusted for monospace dimensions (roughly)
      mvcursor(cx+x,cy+y)
      rgbwr("0",CLR.gold)
    end
    io.flush()
  end
  
  chars = {}
  lines = {}
  for line in io.lines("foo.txt") do
    table.insert(lines,conc(line,"\n"))
    for char in gmch(line,"(.)") do
      table.insert(chars,char)
    end
    table.insert(chars,"\n")
  end
  io.write(table.concat(chars));io.flush()
  slp(2)
  checkcharacter={
    [true]=load([[io.write(chars[j]);]]),
    [false]=load([[io.write(" ");]])
  }
  checknewline={
    [true]=load([[io.write(" ")]]),
    [false]=load([[return ;]])
  }
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
    local wave = 0
    print("inside func 1")
    for i=1,HEIGHT do
      wave = sin((speed*i/10)+state)*opacity
      color = gradient(rgb,background,wave)
      local index = #lines*btoi[i>#lines]+
                    i*btoi[i<=#lines]
      linelength = #lines[index]
      rgbbg(color)
      for j=1,WIDTH do
        local checkcharacter={
          [true]=chars[j],
          [false]=" "
        }
        io.write(checkcharacter[chars[j] ~= nil])
      end
      print()
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
  local end_time = os.clock()
  print("Time taken: ",end_time-start_time,conc("H: ",HEIGHT," W: ",WIDTH));slp(1)
  
  -- TODO: ADD THIS FEATURE AS "pulse_fill_vertical" or something
  checkpulsebreak={[true]=load("breakwait = true"),
                  [false]=load("return ;")}
  pulserate = 45
  duration = 12
  pulselimit = pulserate*duration
  deadline = 0
  breakwait = false;
  pulsestart = os.clock()
  for st=1,pulselimit do
    local pow = math.pow
    deadline = st*((duration)/(pulselimit))
               +pulsestart
    os.execute("tput civis")
    mvcursor(1,1)
    mcu(HEIGHT)
    pulse_fill(4*st/pulselimit,80,0.8,CLR.royalblue,CLR.black)
    print()
    gameprompt(conc("TEST PROMPT -- ",os.clock()-pulsestart),
                    CLR.olive,CLR.beige)
    while breakwait==false do
      checkpulsebreak[os.clock() >= deadline]()
    end
    os.execute("tput cnorm")
    breakwait = false
  end
  collectgarbage("collect");collectgarbage("collect")
  
  -- os.execute("tput cnorm && clear")
  -- os.exit()
  