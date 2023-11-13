testarr = {1,2,3}
for i=1,5000000 do
    local a,b,c = testarr[1],testarr[2],testarr[3]
    io.write(a,b,c);
    io.write("\027[3D");
end
os.exit()