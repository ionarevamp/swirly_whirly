testarr = {1,2,3}
for i=1,5000000 do
    local a,b,c = unpack(testarr,1,#testarr)
    io.write(a,b,c)
    io.write("\027[3D");
end
os.exit()