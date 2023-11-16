function draw_fireball(posx,posy,size,intensity)
    size = size or 25
    cx = posx or CENTER[2]
    cy = posy or CENTER[1]
    local radius = size/2
    local chars = {"O","x","+"}
    os.execute("tput civis;")
    for i=1,size do
        local curgradient = gradientratio(CLR.burntorange,{1,1,1},i,size)
        rgbbg(curgradient)
        mvcursor(1,1)
        print(curgradient[1],curgradient[2],curgradient[3])
        local sqrt = math.sqrt
        local x,y = 0,0
        radius = i/2
        for j=0,(math.pi*2),(math.pi*2)/(360-y) do
            x = radius*cos(j)
            y = radius*sin(j)/3
            mvcursor(cx+x,cy+y)
            rgbwr("0",
                -- gradientratio(
                --     CLR.burntorange,
                --     CLR.red,size-(i/2),
                --     size)
                CLR.red
            )
        end
    end
    io.flush()
    os.execute("tput cnorm")
end