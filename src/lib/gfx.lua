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
        io.flush()
        return ;
    end
    if (flr(x1)==flr(x2)) then
        mvcursor(x1,math.min(y1,y2))
        for i=0,abs(rise) do
            io.write(char)
            mcl()
            mcd()
        end
        io.flush()
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
function drawrect(left,top,right,bottom)
    drawline(left,top,left,bottom)
    drawline(left,top,right,top)
    drawline(left,bottom,right,bottom)
    drawline(right,top,right,bottom)
    io.flush()
end
function draw_circle(cx,cy,size,char)
    char = char or "*"
    local HEIGHT = HEIGHT
    local sqrt = math.sqrt
    local flr = math.floor
    local sin = math.sin
    local cos = math.cos
    size = size or 5
    radius = size/2
    local x,y = 0,0
    local cx = cx or CENTER[2]
    local cy = cy or CENTER[1]
    local dir = 1
    for i=0,360,ratio do
        x = flr(radius*cos(i))
        y = flr(radius*sin(i))/3
        mvcursor(cx+x,cy+y)
        io.write(char)
    end
    io.flush()
end