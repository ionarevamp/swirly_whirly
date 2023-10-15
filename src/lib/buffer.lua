debug = 1
mobile_irl = 0 -- `bc[device == smartphone]` ?
mobile_scale = (0.8*(bc[not mobile_irl==0]))+1*bc[mobile_irl==0] --placeholder estimate
HEIGHT = math.floor(((io.popen('tput lines'):read() or 24) - 1) * ((mobile_scale/ (mobile_irl+1)) or 1))
WIDTH = io.popen('tput cols'):read() or 80
CENTER = { math.ceil(HEIGHT / 2), math.ceil(WIDTH / 2) }


require("src/lib/strings")
--TODO:put code for keeping track of what to print where
-- (and when)
function slp(duration)
  os.execute(conc("sleep ",duration))
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


-- OUTPUT BUFFER CALCULATIONS
