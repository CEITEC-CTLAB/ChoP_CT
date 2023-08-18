function [chp,volume] = ChoP_CT(obr,develop_stage,fourthV)
%obr: imaging data in double format, transverzal slices, head region only
%develop_stage: E13.5, E15.5 or E17.5
%fourthV: downloanded and extracted mask (label) of the fourth ventricle from atlas
%data available here: http://www.mouseimaging.ca/technologies/mouse_atlas/mouse_embryo_atlas.html

%% Preprocessing - median filtration, masking, trimming

filterSize = [3 3 3];
parfor z = 1:size(obr, 3)
    obr(:, :, z) = medfilt2(obr(:, :, z), filterSize(1:2));
end

parfor y = 1:size(obr, 2)
    [sirka,~,vyska] = size(obr(:,y,:));
    s = reshape(obr(:,y,:),sirka,vyska);
    pom = medfilt2(s, filterSize([1 3]));
    obr(:, y, :) = reshape(pom,sirka,1,vyska);
end

parfor x = 1:size(obr, 1)
    [~,sirka,vyska] = size(obr(x,:,:));
    s = reshape(obr(x,:,:),sirka,vyska);
    pom = medfilt2(s, filterSize([2 3]));
    obr(x, :, :) = reshape(pom,1,sirka,vyska);
end

T = graythresh(obr);
skull = imbinarize(obr,T); % mask of tissue
mask_skull_closed = imclose(skull, strel('cube',60));
 for i=size(mask_skull_closed,3):-1:1
    mask_skull_closed(:,:,i) = imfill(mask_skull_closed(:,:,i),'holes');
 end
obr(mask_skull_closed==0) = 0;


mask_skull_closed = bwareaopen(mask_skull_closed,4000); %added

[rowR1,rowR2,colR1,colR2] = cropBCG(mask_skull_closed);
mask_skull_closed = mask_skull_closed(rowR1:rowR2, colR1:colR2,:);
obr = obr(rowR1:rowR2, colR1:colR2,:);
disp('Preprocessing has finished')
%% Ventricles segmentation
% T = graythresh(obr);
disp('Ventricles segmentation has started...')
t = multithresh(obr(obr>0),2);
skull = imbinarize(obr,t(1)); % mask of tissue
skull = bwareaopen(skull,4000); 

holes = zeros(size(mask_skull_closed));
holes = mask_skull_closed - skull; % CSF regions
holes = logical(holes);

if all(develop_stage=='E13.5')
    erosion_value=20;
else 
    erosion_value=10;
end
se = strel('disk', erosion_value); % set as input 
brain_bw = imerode(holes, se);
brain_bw = imdilate(brain_bw, se);
brain_bw = imfill(brain_bw, 'holes');


CC = bwconncomp(brain_bw, 18);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = maxk(numPixels,4);
value = 1000;
idx_ventricle = [];
for i = 1:length(idx)
    ventricle = zeros(size(holes));
    ventricle(CC.PixelIdxList{idx(i)}) = 1;   % Mask of ventricle without plexus...the fourth index is used as the size of the plexus region was eroded 
    if i==1  % expecting that the first index could be an area around brain and the tissue 
        Area = sum(brain_bw(:));
        Area_ventricle = sum(ventricle(:));
        percentage = (Area_ventricle / Area) * 100;
        if percentage > 50 
            continue
        end
    else
    distance = PCsimilarity(ventricle,fourthV);
    end 
    if distance< value
        value = distance;
        idx_ventricle = i;
    end
end 
ventricle = zeros(size(holes));
ventricle(CC.PixelIdxList{idx(idx_ventricle)}) = 1;
ventricle = logical(ventricle); 

obrI = imcomplement(obr);
a = activecontour(obrI,ventricle,150);
t = multithresh(obrI,3);
obrI2 = imbinarize(obrI,t(2));
obrI(obrI2==1) = 1;
b = activecontour(obrI,a,150);


%% LOCALISATION of CHP
closed = imclose(b, strel('cube',30));
CHP_primary = closed - b;
CHP_primary = imopen(CHP_primary, strel('cube',7));
obr_tmp = obr;
obr_tmp(CHP_primary==0) = 0;
obr_tmp = imbinarize(obr_tmp,t(1));

CC=bwconncomp(obr_tmp,18);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = maxk(numPixels,7);
CHP = zeros(size(obr_tmp));
CHP(CC.PixelIdxList{idx(1)}) = 1;

%*check if both are added by comparing left and right branches - in case the
%branches are not connected in the central part of the 4th V
CHP = check_branches(CHP,CC,idx);


if ~strcmp(develop_stage, 'E13.5') % End of the automatic segemntation of the E15.5 and E17.5 embryos

    chp_fin = CHP;
    chp = imbinarize(smooth3(chp_fin,'gaussian'));
    volume = obr;

    sentence = 'Segmentation has finished. Download the mask and new volume as .tiff stack and import it to appropriate program for manual segmentation (AVIZO was used in our case).';
    words = strsplit(sentence, ' ');
    splitIndex = find(cumsum(cellfun('length', words)) >= length(sentence)/2, 1);
    firstPart = strjoin(words(1:splitIndex), ' ');
    secondPart = strjoin(words(splitIndex+1:end), ' ');
    disp(firstPart);
    disp(secondPart);
else
    %% E13.5 SEGMENTATION of CHP based on its LOCATION
    
    n =strel('cube',9); %9
    RF = rangefilt(obr,n.Neighborhood );
    meanrange = mean(RF(CHP==1));
    RF2 = RF>meanrange; %0.85 pre najnovsie e13 embryo
    RF2 = bwareaopen(RF2, 9000, 18);
    chp_RF = add_regions(RF2,CHP);
    
    
    cl = imclose(chp_RF, strel('cube',40));
    obr_tmp2 = obr;
    obr_tmp2(cl==0) = 0;
    t=multithresh(obr_tmp2,2);
    cl2 = imbinarize(obr_tmp2,t(2));
    En2_2 = imopen(cl2, strel('cube',5));
    chp_RF = add_regions(En2_2,CHP);
    
    
    chp_fin = chp_RF;
    chp_fin = activecontour(obr,chp_fin,10); %set as input to function 
    chp = imbinarize(smooth3(chp_fin,'gaussian'));
    volume = obr;
    sentence = 'Segmentation has finished. You can download the mask and import it to appropriate program for 3D visualisation (We used AVIZO).';
    words = strsplit(sentence, ' ');
    splitIndex = find(cumsum(cellfun('length', words)) >= length(sentence)/2, 1);
    firstPart = strjoin(words(1:splitIndex), ' ');
    secondPart = strjoin(words(splitIndex+1:end), ' ');
    disp(firstPart);
    disp(secondPart);
end 











end