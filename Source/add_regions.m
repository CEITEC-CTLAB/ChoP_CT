function [output] = add_regions(mask,CHPregions)
BR_tmp = bwlabeln(mask);
BR_tmp(CHPregions == 0 ) = 0;
BR_tmp = BR_tmp(:);
BR_tmp(BR_tmp==0) = [];
c = unique(BR_tmp);
BR = bwlabeln(mask);
output = zeros(size(mask));
if length(c)>1
    for i=1:length(c)
        pom = BR==c(i);
        output = output + pom;
    end
else
    output = BR==c;
end

end