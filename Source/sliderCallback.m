function sliderCallback(hObject,eventdata)
h=guidata(hObject);
count=round(get(hObject,'Value'));
IM = h.database(:,:,count);
imshow(IM,[])
title(['Slice number: ', num2str(count)]);

% IM=h.database(:,:,1:count);
% IM=permute(IM,[1 2 4 3]);%montage needs the 3rd dim to be the color channel
% montage(IM,'Parent',h.ax);
   
end