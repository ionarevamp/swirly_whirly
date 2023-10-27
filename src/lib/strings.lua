
function charat(text,index)
    return string.sub(text,index,index)
end
function swapflags(flagtable)
    local swaptable = flagtable
    for i=1,#swaptable do
        local flag = swaptable[i]
        if charin(swaptable[i],1) == "-" then
            swaptable[i] = string.sub(flag,2,#flag)
        else
            swaptable[i] = conc("-",flag)
        end
    end
    return swaptable
end
function destring(skillname) --converts skill name into variable name
    for i=1,#skillname do
        if charin(skillname,i) == SPACE then
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
function stringsplit(text,sep)
    local arr = {}
    local delim = conc("[^",sep,"]*")
    local count = 1
    for match in gmch(text,delim) do
        arr[count] = match
        count = count+1
    end
    print(arr)
    return arr
end