local ffi = require("ffi")
ffi.cdef [[
double sin(double x);
]]
x = 1
local sin = ffi.C.sin
os.execute("sleep 1")
for i=1,50000 do
    x = x+sin(i)
    print(x)
    io.write("\027[1A")
end
print(x)