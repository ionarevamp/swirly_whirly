require("src/lib/strings")

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
      OVERLAY[i][j] = SPACE
    end
  end
end
function wipebuff()
  buffclear()
  olclear()
end

function buffwrite(string,row,buffer)
  buffer = buffer or OVERLAY
  for i = 1, #string do
      BUFFER[row][i] = charin(string,i)
  end
end
function update()
  for line in BUFFER do
    for char in line do
      io.write(char)
    end
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
mvdirs = { -- mvdir.r can be used to represent a space
           -- in the OVERLAY buffer as it does not
           -- write over output
  r = "\027[1C",
  l = "\027[1D",
  u = "\027[1A",
  d = "\027[1B"
}

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