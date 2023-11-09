local width = 80
local height = 24
local btoi={[true]=1,[false]=0}

function mvcursor(x,y) -- Non-relative, starts at 1,1
  local flr = math.floor
  local function conc(...) return table.concat({...}) end
  x = flr(x)
  y = flr(y)
  io.write(conc("\027[",y,";",x,"H"))
  -- LINE, then COLUMN
end

function init_screen(width,height)
    local screen = {}
    for y = 1, height do
        screen[y] = {}
        for x = 1, width do
            screen[y][x] = {
                text = "",
                color = 'white'
            }
        end
    end
    return screen
end
-- Function to update a specific coordinate on the screen with a string
function update_screen(screen, x, y, str, color)
    for i = 1, #str do
	
        local str = str:sub(1, (#str-btoi[#str+x>width]*(#str+x-width)) ) or str
        screen[y][x] = {
            text = str,
            color = color
        }
        
        -- Optional: Handle the screen height wrap-around
        -- y = (y + math.floor((x + i - 1) / width)) % height + 1
    end
end

function print_screen(screen)
    for y = 1, height do
        for x = 1, width do
	    mvcursor(x,y)
	    io.write(screen[y][x].text)
        end
    end
end

-- Example usage
local screen = init_screen(width,height)
update_screen(screen, 70, 20, 'Helloooooooooooo', 'blue')
print_screen(screen)
os.exit()
