local ffi = require("ffi")
ffi.cdef [[
double sin(double x);
]]
x = 1
function sin(...) return math.sin(...) end
function ffisin(...) return ffi.C.sin(...) end

print("Using ffi sin function:")
start = os.clock()
for i=1,50000 do
    x = x+ffisin(i)
    print(x)
    io.write("\027[1A")
end
print(x)
print("Total time taken: "..os.clock()-start)

x = 1
print("Using native Lua sin function:")
start = os.clock()
for i=1,50000 do
    x = x+sin(i)
    print(x)
    io.write("\027[1A")
end
print(x)
print("Total time taken: "..os.clock()-start)