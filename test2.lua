function stringreverse(string)
    local arr = {}
    local len = #string
    local sub = string.sub
    for i=0,len-1 do
        arr[i+1] = sub(string,len-i,len-i) -- takes 1 character at index negative i and puts it at index i of the new string
    end
    return table.concat(arr) -- returns table as string
end
print(stringreverse("Hello furls!"))