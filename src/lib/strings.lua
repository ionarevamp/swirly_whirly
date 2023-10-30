
function charat(text,index)
    return string.sub(text,index,index)
end
function swapflags(flagtable)
    local swaptable = flagtable
    for i=1,#swaptable do
        local flag = swaptable[i]
        if charat(swaptable[i],1) == "-" then
            swaptable[i] = string.sub(flag,2,#flag)
        else
            swaptable[i] = conc("-",flag)
        end
    end
    return swaptable
end
function destring(skillname) --converts skill name into variable name
    for i=1,#skillname do
        if charat(skillname,i) == SPACE then
            return conc(
                string.lower(string.sub(skillname,1,i-1)),
                "_",
                string.lower(string.sub(skillname,i+1,#skillname))
            );
        elseif i == #skillname then
            return string.lower(skillname)
        end
    end
end
function getbraced(text,sep)
    -- TODO: FIX FUNCTION
    local max = math.max
    local ins = table.insert
    local arr = {}
    -- local arrmatch = {}
    local arrnomatch = {}
    -- local delim = conc(sep,"[^",sep,"]*",sep)
    local antidelim = conc("[^",sep,"(^",sep,")",sep,"]+")
    -- local count = 1
    -- for match in gmch(text,delim) do
    --     arrmatch[count] = match
    --     count = count+1
    -- end
    count = 1
    for nomatch in gmch(text,antidelim) do
        arrnomatch[count] = nomatch
        count = count+1
    end
    -- local ordercheck = {[true]={arrmatch,arrnomatch},
                --   [false]={arrnomatch,arrmatch}}
    -- local first,second = unpack(ordercheck[charat(text,1)==sep])
    -- local higher = max(#first,#second)
    for i=1,#arrnomatch do
        --ins(arr,first[i])
        ins(arr,arrnomatch[i])
    end
    return arr
end