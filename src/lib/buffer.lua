require("src/lib/strings")
--TODO:put code for keeping track of what to print where
-- (and when)
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
