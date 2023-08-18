function [Volume, r_Volume,Area,r_Area,Angle,amount_of_chp_in_4V] = quantitative_analysis(image_path,mask_path,VoxelSize)
%image_path = path to the tiff images of embryonic brain which were trimmed, thus only the 4th ventricle region is included;
%mask_path = path to the tiff ChP masks hich were trimmed, thus only the 4th ventricle region is included;

%volume, area, angle, GPA, %chp in 4V
    addpath(image_path)
    addpath(mask_path)


    path = dir([image_path,'\*tif'])
    obr=[];
    for i=1:length(path)
        path_tiff = path(i,1).name;
        obr(:,:,i) = rgb2gray(imread([path_tiff]));
    end
    


    
    path = dir([mask_path,'\*tif'])
    chp=[];
    for i=1:length(path)
        path_tiff = path(i,1).name;
        chp(:,:,i) = imbinarize(rgb2gray(imread([path_tiff])));
    end
    %% Volume
    
    v = regionprops3(chp,'Volume');
    Volume = sum(v.Volume* (VoxelSize*VoxelSize*VoxelSize)); %mm3
    r_Volume = nthroot((Volume*(3/4)/pi), 3); %mm
    %% Area
    a = regionprops3(chp,'SurfaceArea');
    Area = a.SurfaceArea*(VoxelSize*VoxelSize);
    r_Area = sqrt(Area/(4*pi));
    %% Angle
    RP = regionprops3(chp,'Centroid','EigenVectors','EigenValues');
    centroid = [RP.Centroid(1) RP.Centroid(2) RP.Centroid(3)];
    eigenVal = RP.EigenValues{:};
    eigenVec = RP.EigenVectors{:};
    vector = eigenVec(1,:);
    Angle = acos(vector(2)/sqrt((vector(1)^2)+(vector(2)^2)+(vector(3)^2)));
    Angle = rad2deg(Angle); %IN ZY plane chcem XZ
    %% %chp in 4V
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
    FirstSliceIndex = evalin('base', 'FirstSliceIndex');
    LastSliceIndex = evalin('base', 'LastSliceIndex');
    guidata(h.f,h)
    
    sliderCallback(h.slider) 
    numImages

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

end