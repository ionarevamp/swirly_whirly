x = 1
function sin(...) return math.sin(...) end
os.execute("sleep 1")
for i=1,50000 do
    x = x+sin(i)
    print(x)
    io.write("\027[1A")
end
print(x)