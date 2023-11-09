require("src/lib/strings")

mvdirs = { -- mvdirs.r can be used to represent a space
           -- in the OVERLAY buffer as it does not
           -- write over output
  r = "\027[1C",
  l = "\027[1D",
  u = "\027[1A",
  d = "\027[1B"
}

function initscreen(width,height)
  local screen = {}
  for y = 1, height do
      screen[y] = {}
      for x = 1, width do
          screen[y][x] = {
              text = "",
              fgcolor = FGCOLOR,
              bgcolor = BGCOLOR
          }
      end
  end
  return screen
end
function tobuffer(x, y, str, fgcolor, bgcolor, screen)
  screen = screen or SCREEN[1]
  fgcolor = fgcolor or FGCOLOR
  bgcolor = bgcolor or BGCOLOR
  for i = 1, #str-(btoi[#str+x>#screen[1]]*(#str+x-#screen[1])) do
    local str = str:sub(i, i) or str
    screen[y][x+i] = {
      text = str,
      fgcolor = fgcolor,
      bgcolor = bgcolor
      }
  end
end
function clearbuffline(y,screen) -- y coordinate is equivalent to row from top
  screen = screen or SCREEN[1]
  for x = 1, #screen[y] do
    screen[y][x].text = ""
    screen[y][x].fgcolor = FGCOLOR
    screen[y][x].bgcolor = BGCOLOR
  end
end
function clearbuff(screen)
  screen = screen or SCREEN[1]
  for y = 1, #screen do
    clearbuffline(y,screen)
  end
end
function clearbuffer(...)
  clearbuff(...)
end

-- DEBUG
function showcmd(t)
  local lines = {}
  for val in gmch(CMDS[t], "[^;]+") do
    table.insert(lines,val)
  end
  for i=1,#lines do
    if i==1 then print(t,lines[i]) else
      print(" ",lines[i])
    end
  end
end
function showtable(t)
  local lines = {}
  for key,val in pairs(t) do
    for val in gmch(vals, "[^;]+") do
      table.insert(lines,val)
    end
    for i=1,#lines do
      if i==1 then print(key,lines[i]) else
        print(" ",lines[i])
      end
    end
  end
end


-- OUTPUT BUFFER CALCULATIONS

BUFFER = {}          
for i=1,HEIGHT do
  BUFFER[i] = {}     
  for j=1,WIDTH do
    BUFFER[i][j] = SPACE
  end
end --initializes a matrix full of blank spaces
-- ^^ allows changes to be made to the buffer before
-- printing each character
ALTBUFFER = {}          
for i=1,HEIGHT do
  ALTBUFFER[i] = {}     
  for j=1,WIDTH do
    ALTBUFFER[i][j] = SPACE
  end
end
OVERLAY = {}          
for i=1,HEIGHT do
  OVERLAY[i] = {}     
  for j=1,WIDTH do
    OVERLAY[i][j] = SPACE
  end
end
-- ^^ separate buffer specifically for preserving
-- existing screen content during draw


function buffclear()
  for i=1,HEIGHT do
    BUFFER[i] = {}     
    for j=1,WIDTH do
      BUFFER[i][j] = SPACE
    end
  end
end
function olclear()
  for i=1,HEIGHT do
    OVERLAY[i] = {}     
    for j=1,WIDTH do
      OVERLAY[i][j] = mvdirs.r
    end
  end
end
function wipebuff()
  buffclear()
  olclear()
end
function loadbuff(string,row)
  row = row or 1
  for i = 1, #string do
      BUFFER[row][i] = charat(string,i)
  end
end
function buffer_file(file,start,buffer)
  buffer = buffer or BUFFER
  start = start or 1
  loaded = io.open(file)
  local block_length = loaded:read("*n")
  local lines = {}
  local count = 1
  for line in loaded:lines() do
    lines[count] = line
    count = count + 1
  end

  for i=start,block_length+1 do
    local limit = flr(#lines[i]*1)-1
    io.write(conc(#lines,",",limit," "))
    for j=1,limit do
      local char = charat(lines[i],j)
      buffer[i][j] = char
    end
  end
  loaded:close()
end
-- Monster loading
function loadmon(name,x,y)

end
function overlay_file(file,start)
  start = start or 1
  loaded = io.open(file)
  local block_length = loaded:read("*n")
  for i=start,block_length do
    local line = loaded:read("*l")
    for j=1,#line do
      OVERLAY[i+(start-1)][j] = charat(line,j)
    end
  end
  loaded:close()
end
function update()
  for i=1,#BUFFER do
    for j=1,#BUFFER[i] do
      io.write(BUFFER[i][j])
    end
    print()
  end
end
function overdraw()
  for line in OVERLAY do
    for char in line do
      io.write(char)
    end
  end
end


-- CURSOR CONTROL
--[[refer to
https://notes.burke.libbey.me/ansi-escape-codes/
or similar
]]

function savecursor() io.write("\027[s") end
function loadcursor() io.write("\027[u") end

--uses table indexing to avoid (slow) branching
local determine_break = {[true]="",[false]="io.write('');"}
local determine_horizontal = {[true]="C",[false]="D"}
local determine_vertical = {[true]="B",[false]="A"}
function mvcursor(x,y) -- Non-relative, starts at 1,1
  x = flr(x)
  y = flr(y)
  io.write(conc("\027[",y,";",x,"H"))
  -- LINE, then COLUMN
end
function mvalign(string,ypos)
  mvcursor((CENTER[2]-(#string/2)),ypos)
end
function mcr(distance) -- M.ove C.ursor. R.ight
  distance = flr(distance or 1)
  io.write(conc("\027[",distance,"C"))
end
function mcl(distance) -- left
  distance = flr(distance or 1)
  io.write(conc("\027[",distance,"D"))
end
function mcu(distance) -- up
  distance = flr(distance or 1)
  io.write(conc("\027[",distance,"A"))
end
function mcd(distance) -- down
  distance = flr(distance or 1)
  io.write(conc("\027[",distance,"B"))
end
function mch(distance, dir) -- M.ove C.ursor H.orizontal
  local mmax = math.max
  local direction = "D"
  if dir > 0 then direction = "C" end
  distance = flr(math.abs(distance))
  io.write(distance,direction," ")
  io.write(conc("\027[",tostring(distance),direction))
end
function mcv(distance) -- M.ove C.ursor V.ertical
  local direction = determine_vertical[distance>0]
  distance = flr(distance or 1)
  io.write(conc("\027[",distance,direction))
end
function mvhor(xpos)
  xpos = xpos or 1
  xpos = flr(xpos)+btoi[flr(xpos)<1] --revert to 1 if 0
  io.write(conc("\027[",xpos,"G"))
end
function totop()
  mvcursor(1,1)
end
function clr()
  io.write("\027[2J\027[1;1H")
  --rgbreset()
end
function clrline()
  io.write("\027[2K\027[1G")
end
function toleft()
  mvhor(1)
end

-- RANDOMNESS
charidarr = {}
for i=1,95 do
  table.insert(charidarr,i+31)
end
function randchar()
  local range = flr((math.random()*#charidarr))
  return tostring(string.char(charidarr[range] or 126))
end
function prc()
  io.write(randchar())
end
function prcln()
  print(randchar())
end

-- ALIGN TEXT
function c_align(string)
  string = string or ""
  mcr(flr(CENTER[2]-(#string/2)-1))
end
function c_write(string)
  string = string or ""
  c_align(string)
  io.write(string)
end
function c_print(string)
  string = string or ""
  c_write(conc(string,"\n"))
end
