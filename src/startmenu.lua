dofile("src/lib/gfx.lua")
-- NOTE: this sequence assumes that there is a way
--  to return to the previous screen, such as
--  displaying from the pre-existing buffer
 --some value plus one
 function hilitesep(text,rgb,sep,layer)
    sep = sep or "'"
    layer = layer or 3
    local charcheck = {[true]=sep,[false]=""}
    local r,g,b = unpack(rgb)
    local prevr,prevg,prevb = unpack(FGCOLOR)
    local arr = getbraced(text,sep)
    local check = 0
    for i=(1+bc[charat(text,1)~=sep]),#arr,2 do
        -- local i = i-bc[i>(#arr-1) and charat(text,#text)~=sep]
        arr[i] = table.concat({sep,
        "\27[",layer,"8;2;",
        r,";",g,";",b,"m",arr[i],
        "\27[",layer,"8;2;",
        prevr,";",prevg,";",prevb,"m",sep}
        )
    end
    return table.concat(arr);
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
    for i=1,#selections do
        mvalign(selections[i],2*i)
        io.write(hilitesep(selections[i],colors[i]))
    end
    rgbset(prev_color)
    print();print()
end

drawline(1,1,WIDTH,HEIGHT)
for i=1,HEIGHT do print() end
::select_option::
totop()
rgbreset()
border(startmenu.optioncount * 2)
-- print(hilitesep("'funny' world of 'fun' and 'dreams' a'a'",CLR.red,"'"))
gameprompt("Make your choice...",
            {12,12,12},
            {150,150,150})
mainchoice = lower(io.read())
if mainchoice == "begin" then goto exit_menu
elseif mainchoice == "load" then
    --[[load game files]]
    blankerr()
elseif mainchoice == "options" then
    --[[display options menu]]
    blankerr()
elseif mainchoice == "quit" then
     quit = 1
     goto exit_menu
end
rgbreset()
goto select_option
::exit_menu::