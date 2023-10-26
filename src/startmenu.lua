dofile("src/lib/gfx.lua")
-- NOTE: this sequence assumes that there is a way
--  to return to the previous screen, such as
--  displaying from the pre-existing buffer
 --some value plus one
function border(height)
    height = height or 20
    local selections = {startmenu.begin,
                        startmenu.load,
                        startmenu.options,
                        startmenu.exit}
    local colors = {CLR.green,
                    CLR.orange,
                    CLR.darkorange,
                    CLR.burlywood}
    local lines = flr(height+1)
    local WIDTH = WIDTH-1
    rgbwr("",CLR.blue)
    drawrect({1,1},{WIDTH,lines})
    for i=1,#selections do
        rgbset()
        mvalign(selections[i],2*i)
        io.write(hilitesep(selections[i],"()'()",colors[i]))
    end
    rgbreset()
    print()
    clrline();
end
clr()
for i=1,HEIGHT do print() end
totop()

border(startmenu.optioncount * 2)
print()
mcl(WIDTH)
gameprompt("Make your choice... ",
            {12,12,12},
            {150,150,150})
--mainchoice = io.read()

rgbreset()