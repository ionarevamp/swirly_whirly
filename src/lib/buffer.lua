require("src/lib/strings")

mvdirs = { -- mvdirs.r can be used to represent a space
           -- in the OVERLAY buffer as it does not
           -- write over output
  r = "\027[1C",
  l = "\027[1D",
  u = "\027[1A",
  d = "\027[1B"
}

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

function loadbuffer(string,row)
  row = row or 1
  for i = 1, #string do
      BUFFER[row][i] = charin(string,i)
  end
end

function buffer_file(file,start)
  start = start or 1
  loaded = io.open(file)
  local block_length = loaded:read("*n")
  local lines = {}
  local count = 1
  for line in loaded:lines() do
    lines[count] = line
    count = count + 1
  end
  for i=1,block_length do
    for j=1,#lines[i] do
      local char = charin(lines[i],j)
      BUFFER[i+(start-1)][j] = char
    end
  end
  loaded:close()
end

function overlay_file(file,start)
  start = start or 1
  loaded = io.open(file)
  local block_length = loaded:read("*n")
  for i=start,block_length do
    local line = loaded:read("*l")
    for j=1,#line do
      OVERLAY[i+(start-1)][j] = charin(line,j)
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
function c_align(string)
  string = string or ""
  mcr(math.ceil(CENTER[2]-(#string/2)))
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