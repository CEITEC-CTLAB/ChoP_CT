N_images=size(obr,3);
numImages = size(obr,3);
currentImageIndex = 1;
global myGlobalVariable;
myGlobalVariable = false;
%prepare figure and guidata struct
h=struct;
h.f=figure;
h.ax=axes('Parent',h.f,...
    'Units','Normalized',...
    'Position',[0.1 0.1 0.6 0.8]);
h.slider=uicontrol('Parent',h.f,...
    'Units','Normalized',...
    'Position',[0.8 0.1 0.1 0.8],...
    'Style','Slider',...
    'BackgroundColor',[1 1 1],...
    'Min',1,'Max',N_images,'Value',1,...
    'Callback',@sliderCallback);
slider = h.slider; 
saveButton = uicontrol('Style', 'pushbutton', 'String', 'First', ...
    'Units', 'normalized', 'Position', [0.4, 0.01, 0.2, 0.04], ...
    'Callback', @(src,~) buttonDown(src,slider));
finishButton = uicontrol('Style', 'pushbutton', 'String', 'Finish', ...
    'Units', 'normalized', 'Position', [0.2, 0.01, 0.2, 0.04], ...
    'Callback', @buttonDownFinish);
saveButtonClicked = false;
savedImageNumber = [];
set(gcf, 'UserData', struct('buttonPressed', false));

%store image database to the guidata struct as well
h.database=obr;
guidata(h.f,h)

sliderCallback(h.slider)


%% 

fourthV = obr(:,:,FirstSliceIndex:LastSliceIndex);
t = multithresh(fourthV(fourthV>0),2);
fourthV = imbinarize(fourthV,t(1));
maska = imclose(fourthV, strel('cube',60));
 for i=size(maska,3):-1:1
    maska(:,:,i) = imfill(maska(:,:,i),'holes');
 end
obr(maska==0) = 0;
binaryImageSwapped = fourthV == 0;
maska = imerode(maska,strel('cube',20));
binaryImageSwapped(maska==0) = 0;

CC=bwconncomp(binaryImageSwapped,18);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = maxk(numPixels,7);
fV = zeros(size(binaryImageSwapped));
fV(CC.PixelIdxList{idx(2)}) = 1;

v = regionprops3(fV,'Volume');
Volume_4V = v.Volume* (VoxelSize*VoxelSize*VoxelSize); %mm3
amount_of_chp_in_4V = (Volume/(Volume+Volume_4V))*100;
