function charin(string, index)
    return string.sub(string,index,index)
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