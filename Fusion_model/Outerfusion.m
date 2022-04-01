function Outfeature = Outerfusion(finalfeature,dimension,wsize)
m = 0;
for i = 1:dimension-1
    for j = i+1:dimension
        m = m+1;
        Outfeature(:,:,m) = guidefilterfusion(finalfeature(:,:,i),finalfeature(:,:,j),wsize,0.02);
    end
end
end