dofile("src/lib/gfx.lua")
-- NOTE: this sequence assumes that there is a way
--  to return to the previous screen, such as
--  displaying from the pre-existing buffer
 --some value plus one
 function hilitepos(text,rgb,sep,layer)
    -- broken function and my brain is tired...
    sep = sep or "'"
    layer = layer or 3
    if (layer ~= 3) and (layer ~= 4) then return ; end
    local r,g,b = unpack(rgb)
    local arr = stringsplit(text,sep)
    for i=1,#arr-1 do
        arr[i] = conc(arr[i])
    end
    print(table.concat(arr))
    return ;
end
function border(height)
    height = height or 20
    local selections = {startmenu.begin,
                        startmenu.load,
                        startmenu.options,
                        startmenu.exit}
    local colors = {CLR.green,
                    CLR.darkorange,
                    CLR.lavender,
                    CLR.burlywood}
        -- same amount of colors as selections
    local lines = flr(height+1)
    local WIDTH = WIDTH-1
    local prev_color = FGCOLOR
    rgbset(CLR.powderblue)
    drawrect(1,1,WIDTH,lines)
    -- for i=1,#selections do
    --     mvalign(selections[i],2*i)
    --     Cwrite(hilitesep(selections[i],colors[i]))
    -- end
    rgbset(prev_color)
    print()
end

drawline(1,1,WIDTH,HEIGHT)
for i=1,HEIGHT do print() end
totop()
rgbreset()
border(startmenu.optioncount * 2)
print();print()
gameprompt("Make your choice...",
            {12,12,12},
            {150,150,150})
-- mainchoice = io.read()

rgbreset()
