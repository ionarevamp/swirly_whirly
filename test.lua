print("Hello WORLD");
bc = {[false]=0,[true]=1}
function max255(r,g,b)
	r = (255*bc[r>255])+(r*bc[r<255]);
	g = (255*bc[g>255])+(g*bc[g<255]);
	b = (255*bc[b>255])+(b*bc[b<255]);
	return {r,g,b}
end
for i=1,260 do
	print(unpack(max255(i,i,i)))
end

