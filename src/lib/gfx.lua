function drawline(x1,y1,x2,y2,char)
    local char = char or "*"
    local ceil = math.ceil
    local abs = math.abs
    local rise = y2-y1
    local run = x2-x1
    if (flr(y1) == flr(y2)) then
        local run = abs(run)
        mvcursor(x1,y1)
        for i=1,run do
            io.write(char)
        end
        return ;
    end
    if (flr(x1)==flr(x2)) then
        mvcursor(x1,math.min(y1,y2))
        for i=0,abs(rise) do
            io.write(char)
            mcl()
            mcd()
        end
        return ;
    end
    local slope = rise/run
    local inverse_slope = run/rise
    local detail = math.max(abs(slope),abs(inverse_slope))
    local distance = math.sqrt((abs(rise)^2)+(abs(run)^2))
    for i=1,distance*detail do
        local i = i/detail
        mvcursor(x1+(slope*i),y1+(inverse_slope*i))
        io.write(char)
    end
    io.flush()
end
function drawrect(topl,bottomr)
    drawline(topl[1],topl[2],topl[1],bottomr[2])
    drawline(topl[1],topl[2],bottomr[1],topl[2])
    drawline(topl[1],bottomr[2],bottomr[1],bottomr[2])
    drawline(bottomr[1],topl[2],bottomr[1],bottomr[2])
    io.flush()
end
