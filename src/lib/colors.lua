CLR = {
    white = {255, 255, 255},
    black = {0, 0, 0},
    red = {255, 0, 0},
    lime = {0, 255, 0},
    blue = {0, 0, 255},
    yellow = {255, 255, 0},
    cyan = {0, 255, 255},
    magenta = {255, 0, 255},
    darkgray = {25, 25, 25},
    palegray = {80, 80, 80},
    gray0 = {180, 180, 180},
    gray1 = {185, 185, 185},
    gray2 = {190, 190, 190},
    silver = {192, 192, 192},
    brightsilver = {217, 218, 219},
    gray = {128, 128, 128},
    maroon = {128, 0, 0},
    olive = {128, 128, 0},
    green = {0, 128, 0},
    purple = {128, 0, 128},
    teal = {0, 128, 128},
    navy = {0, 0, 128},
    orange = {255, 165, 0},
    darkorange = {255, 140, 0},
    litorange = {255, 100, 50},
    burntorange = {205, 85, 0},
    pink = {255, 192, 203},
    brown = {165, 42, 42},
    coral = {255, 127, 80},
    gold = {255, 223, 0},
    goldmetal = {212, 175, 55},
    violet = {238, 130, 238},
    khaki = {240, 230, 140},
    lavender = {230, 230, 250},
    beige = {245, 245, 220},
    salmon = {250, 128, 114},
    chocolate = {210, 105, 30},
    plum = {221, 160, 221},
    indigo = {75, 0, 130},
    honeydew = {240, 255, 240},
    chartreuse = {127, 255, 0},
    azure = {240, 255, 255},
    aquamarine = {127, 255, 212},
    slategray = {112, 128, 144},
    lightpink = {255, 182, 193},
    tan = {210, 180, 140},
    peachpuff = {255, 218, 185},
    powderblue = {176, 224, 230},
    skyblue = {135, 206, 235},
    mediumvioletred = {199, 21, 133},
    firebrick = {178, 34, 34},
    burlywood = {222, 184, 135},
    sandybrown = {244, 164, 96},
    mediumorchid = {186, 85, 211},
    antiquewhite = {250, 235, 215},
    royalblue = {65, 105, 225},
    goldenrod = {218, 165, 32},
    thistle = {216, 191, 216},
    turquoise = {64, 224, 208}
}
CLRV = {} -- TODO:for each CLR, create RGB vector via:
    -- value * 100 / 255 = percentage
function gradient(rgb,rgb2,percent,dir) 
    -- MUST accept non-empty table
    -- percentage as value from 0 to 1
    dir = dir or 1 --takes 1 or -1
    local rgb = rgb
    local rgb2 = rgb2
    local mathabs = math.abs
    local gradient = {}
    local diffs = {}
    for i=1,3 do
        diffs[i] = mathabs(rgb2[i]-rgb[i])
        gradient[i] = rgb[i]+(dir*(diffs[i]*percent))
    end
    return gradient
end
function gradientratio(rgb1,rgb2,iter,limit,dir)
    return gradient(rgb1,rgb2,(iter*(1/limit)),dir)
end
-- function hilitesep(string,sep,rgb,layer)
--     layer = layer or 3
--     if (layer ~= 3) and (layer ~= 4) then return ; end
--     local r,g,b = unpack(rgb)
--     local arr = {}
--     for token in gmch(string,sep) do
--         table.insert(arr,conc(token,sep))
--     end
--     for i=1,(#arr/2) do
--         arr[i*2]=conc(
--             "\027[",layer,"8;2;",r,";",g,";",b,"m",
--             arr[i*2],"\027[0m")
--     end
--     return conc(arr)
-- end
decidelayer = {[3]=FGCOLOR,[4]=BGCOLOR}
function hilite(string,match,rgb,layer)
    local gsub = string.gsub
    layer = layer or 3
    local prevcolor = decidelayer[layer]
    if (layer ~= 3) and (layer ~= 4) then return ; end
    local r,g,b = rgb[1],rgb[2],rgb[3]
    local pr,pg,pb = prevcolor[1],prevcolor[2],prevcolor[3]
    return gsub(string,match,
            conc( "\027[",layer,"8;2;",r,";",g,";",b,"m",
            "%1", -- text to highlight
            "\027[",layer,"8;2",pr,";",pg,";",pb,"m" )
        );
end