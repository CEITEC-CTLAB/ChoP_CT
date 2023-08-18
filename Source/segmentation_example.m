clear; clc;
%% Load image stack
path = dir('Your Path Goes Here\*tif')  % you can use different image format by editing writing it after *
addpath('Same Path')

obr=[];

% transverzal slices - head region only

parfor i=1:length(path)
    path_tiff = path(i,1).name;
    obr(:,:,i) = im2double(rgb2gray(imread([path_tiff])));
    
end

if max(max(max(obr)))>1 && max(max(max(obr)))<257
        obr = double(obr)/255;
elseif max(max(max(obr)))>257 
        obr = double(obr)/65535;
end

% download and load mask for 4th ventricle reference 
path = dir('U:\DP\4V\*tif')
addpath('U:\DP\4V')

fourthV=[];

parfor i=1:length(path)
    path_tiff = path(i,1).name;
    fourthV(:,:,i) = im2double(imread([path_tiff]));
    
end

% transversal slices, begining with head if not - transformation
fourthV = imrotate(fourthV, -90);
fourthV = flip(fourthV,3);

disp('Data were loaded successfully')

%% Segmentation
[chp, volume] = ChoP_CT(obr,'E13.5',fourthV);

%% Figures
imshow3D(chp)

figure
c='put some number of slice you want to visualise';
s= volume(:,:,c);
imshow(s,[])
hold on
o = helper(:,:,c);
B = bwboundaries(chp);
visboundaries(B)

%% Save the data 
for i=1:size(chp,3)
    imwrite(chp(:,:,i),['mask',num2str(i),'.tiff'],'tiff');
end

for i=1:size(volume,3)
    imwrite(volume(:,:,i),['vol',num2str(i),'.tiff'],'tiff');

end

%% Quantitative and morphological analysis - AUTO
image_path = 'Path to volume imaging data which were exported';
mask_path = 'Path to chp imaging data which were exported';
[Volume, r_Volume,Area,r_Area,Angle,amount_of_chp_in_4V] = quantitative_analysis(image_path,mask_path,0.0043);

disp(['Volume: ',num2str(Volume),' mm3'])
disp(['Area: ',num2str(Area), ' mm2'])
disp(['Angle: ',num2str(Angle), '°'])
disp(['%chp in 4V: ',num2str(amount_of_chp_in_4V), '%'])

%% GPA
% Upload landmarks for each model here. Example is using 3 datasets
MUT1=[0.9380139112472534,0.6169557571411133,0.6350059509277344;
0.9397923946380615,0.8496782779693604,0.6636075973510742;
2.413241147994995,0.6032885313034058,0.700337290763855;
2.4539618492126465,0.8300496935844421,0.6700932383537292;
0.6291012763977051,0.30896449089050293,0.8759872317314148;
2.825817584991455,0.214593306183815,0.9325334429740906]; %15.5
MUT2=[0.9632344245910645,0.67206209897995,0.6351500749588013;
1.0400564670562744,1.0154162645339966,0.7664733529090881;
2.4608561992645264,0.5855287909507751,0.5999274849891663;
2.450629711151123,0.9550666809082031,0.7345322966575623;
0.47295328974723816,0.39889588952064514,0.8778524994850159;
2.8937320709228516,0.21002455055713654,0.9514681696891785]; %15.5
MUT3=[1.0218585729599,0.6620517373085022,0.6061504483222961;
1.0011334419250488,1.0012636184692383,0.7687373757362366;
2.3805534839630127,0.7113754153251648,0.6196991801261902;
2.3719725608825684,0.9145023822784424,0.7353610992431641;
0.526971161365509,0.3557429909706116,0.9315166473388672;
2.874197244644165,0.3856829106807709,0.9393953084945679]; %15.5

% Upload Landmarks of mean model generated for the embryonic stage of
% already uploaded models MUT1, MUT2 and MUT3 (these models must have the same develop. stage)
MM=[1.2463598251342773,0.7688607573509216,0.7709197998046875;
1.2427479028701782,0.9045519232749939,0.7174465656280518;
2.166980028152466,0.8045226335525513,0.7209824323654175;
2.1758205890655518,0.9200790524482727,0.6937969923019409;
0.6572962403297424,0.40461769700050354,0.8352901339530945;
2.717728853225708,0.43527472019195557,0.82342529296875];

myStructure.MUT1 = MUT1;
myStructure.MUT2 = MUT2;
myStructure.MUT3 = MUT3;

d = GPA(myStructure,MM);

X = categorical({'E13.5 MUT1',...
    'E13.5 MUT2', 'E13.5 MUT3'});
bar(d)
ylabel('Procrustes distance')




