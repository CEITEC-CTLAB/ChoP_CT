function [mask] = check_branches(mask,CC,idx)
w_half = floor(size(mask,1)/2);
[~, col, ~] = ind2sub(size(mask), find(mask));
start_index = min(col);
end_index = max(col);
roi_rightB = mask(1:w_half,start_index:end_index,:);
roi_leftB = mask(w_half:end,start_index:end_index,:);
sum_roi_rightB = sum(roi_rightB(:));
sum_roi_leftB = sum(roi_leftB(:)); 

if sum_roi_leftB==0 || sum_roi_rightB==0
   mask(CC.PixelIdxList{idx(2)}) = 1;
else 
    figure; 
    imshow3D(mask)
    answer = input('Are both HbChP branches included? (yes/no): ', 's');
    close;
    if strcmpi(answer, 'no')
        mask(CC.PixelIdxList{idx(2)}) = 1;
        imshow3D(mask)
        disp('Second branch was added')
    end

end 


end