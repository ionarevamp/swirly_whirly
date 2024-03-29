-- NOTE: this sequence assumes that there is a way
--  to return to the previous screen, such as
--  displaying from the pre-existing buffer
function hilitesep(text,rgb,sep,layer)
    sep = sep or "'"
    layer = layer or 3
    local charcheck = {[true]=sep,[false]=""}
    fr,fg,fb = rgb[1],rgb[2],rgb[3]
    local prevr,prevg,prevb = FGCOLOR[1],FGCOLOR[2],FGCOLOR[3]
    local arr = getbraced(text,sep)
    local check = 0
    for i=(1+btoi[charat(text,1)~=sep]),#arr,2 do
        -- local i = i-btoi[i>(#arr-1) and charat(text,#text)~=sep]
        arr[i] = conc(sep,
        "\027[",layer,"8;2;",
        fr,";",fg,";",fb,"m",arr[i],
        "\027[",layer,"8;2;",
        prevr,";",prevg,";",prevb,"m",sep)
    end
    return table.concat(arr);
end
function showstartmenu(height)
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

for i=1,HEIGHT do print() end

validoption = true
::select_option::
loadcursor()
clr()
rgbreset()

showstartmenu(startmenu.optioncount * 2)
mvcursor(1,HEIGHT-2)
gameprompt("Make your choice...",
            {12,12,12},
            {150,150,150})
rgbwr("(case insensitive)",{80,80,80})
rgbreset()
toleft()
if not validoption then
    print("\nPlease type an appropriate selection.")
    mcu()
end

mainchoice = string.lower(io.read())
if mainchoice == "begin" then
    goto creation_menu
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
validoption = false
goto select_option

-- CHARACTER CREATION
::creation_menu::
Player = nil;
function createPlayer()
    loadcursor()
    clr()
    rgbline("Races: ",CLR.darkgray,CLR.gold)
    for i=1,#racenames do
        print(capitalizesentence(racenames[i]))
    end
    mvcursor(1,HEIGHT-2)
    gameprompt("Make your choice...",
            {12,12,12},
            {150,150,150})
    rgbwr("(case insensitive)",{80,80,80})
    rgbreset()
    toleft()
    local racechoice = string.lower(io.read())
    mvcursor(1,#racenames+2)
    rgbline("Backgrounds: ",CLR.darkgray,
        gradient(CLR.brown,CLR.slategray,0.5))
    for i=1,#backgroundnames do
        print(capitalizesentence(backgroundnames[i]))
    end
    mvcursor(1,HEIGHT-2)
    gameprompt("Make your choice...",
            {12,12,12},
            {150,150,150})
    rgbwr("(case insensitive)",{80,80,80})
    rgbreset()
    toleft()
    local backgroundchoice = string.lower(io.read())

end
USERSAVE = io.open("user/save.file","r")
if USERSAVE == nil then
    print("No save file detected. Entering character creation...")
    createPlayer()
else goto exit_menu
end
::exit_menu::