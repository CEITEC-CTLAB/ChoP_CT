function [rowR1,rowR2,colR1,colR2] = cropBCG(mask)
rowR1 = Inf;
colR1 = Inf;
rowR2 = 0;
colR2 = 0;
for i=1:size(mask,3)
    [r, c] = find(mask(:,:,i)==1);
    r(r<10) = [];
    r(r>(size(mask,1)-10)) = [];
    c(c<10) = [];
    c(c>(size(mask,2)-10)) = [];
    row1 = min(r); row2 = max(r); col1 = min(c); col2 = max(c);
    if row1<rowR1
        rowR1 = row1;
    end
    if row2>rowR2
        rowR2 = row2;
    end
    if col1<colR1
        colR1=col1;
    end
    if col2>colR2
        colR2=col2;
    end
end

end