
%% Quantitative and morphological analysis
image_path = 'Q:\Buchtova\Cdk13 mouse\E13.5\0 wt\Cdk13 E13.5 A9-1 wtA\ChP - Viktoria\vol';
mask_path = 'Q:\Buchtova\Cdk13 mouse\E13.5\0 wt\Cdk13 E13.5 A9-1 wtA\ChP - Viktoria\chp';
[Volume, r_Volume,Area,r_Area,Angle,amount_of_chp_in_4V] = quantitative_analysis(image_path,mask_path,0.0043);

disp(['Volume: ',num2str(Volume),' mm3'])
disp(['Area: ',num2str(Area), ' mm2'])
disp(['Angle: ',num2str(Angle), '°'])
disp(['%chp in 4V: ',num2str(amount_of_chp_in_4V), '%'])
%% Plot results

names = categorical({'WT E13.5','WT E13.5','WT E13.5','WT E13.5','WT E13.5','WT E15.5','WT E15.5','WT E15.5','WT E15.5','WT E15.5','WT E17.5','WT E17.5','WT E17.5','WT E17.5','WT E17.5',});
Volume = [0.024 0.018 0.017 0.011 0.02; 0.039 0.048 0.049 0.047 0.054; 0.06 0.06 0.05 0.06 0.052];
Area = [1.2 0.9 0.66 0.52 0.96;2.45 3.1 3.11 3.06 2.97;3.33 3.32 3.27 2.69 2.39];


chpin4V = [4.109589041 4.306220096 2.847571189 2.552204176 5.714285714;...
  17.03056769 20.16806723 14.89361702 20.70484581 17.19745223;...
  33.33333333 40.54054054 45.45454545 65.93 53.06122449];

Angle = [54 59 56 54 37; 50 116 96 101 99; 74 75 78 56 58];

UBpart = [37 63; 39 61; 50 50; 50 50; 40 60; 24 76; 40 60; 33 67; 34 66; 44 56; 38 62; 32 68; 44 56; 31 69; 46 54];
LRangle = [60 60; 50 54; 59 52; 59 59; 43 48; 0 0 ;58 59; 60 58; 64 59;65 65];
angleLRmut(LRangle)


% UBMut = [43 57; 42 58; 62 38; 90 10; 60 40;35 65;26 74; 29 71; 35 65; 58 60; 60 58; 64 59; 65 65];


Left = [41 59 ; 33 67; 46 55; 38 62];
Right = [40 60;38 62; 39 61;38 62];

stackData = zeros (4, 2, 2);
stackData(1,1,:)= Left(1,:);
stackData(1,2,:)= Right(1,:);
stackData(2,1,:)= Left(2,:);
stackData(2,2,:)= Right(2,:);
stackData(3,1,:)= Left(3,:);
stackData(3,2,:)= Right(3,:);
stackData(4,1,:)= Left(4,:);
stackData(4,2,:)= Right(4,:);
% stackData(5,1,:)= Left(5,:);
% stackData(5,2,:)= Right(5,:);

bar(LRangle,'grouped')
set(gca,'width',0.1)
bar(LRangle(6:10,:),'grouped')
bar(LRangle(6:10,:),'grouped')


stackData = zeros (2, 5, 2);
stackData(1,1,:)= LRangle(1,:);
stackData(1,2,:)= LRangle(2,:);
stackData(1,3,:)= LRangle(3,:);
stackData(1,4,:)= LRangle(4,:);
stackData(1,5,:)= LRangle(5,:);

stackData(2,1,:)= LRangle(6,:);
stackData(2,2,:)= LRangle(7,:);
stackData(2,3,:)= LRangle(8,:);
stackData(2,4,:)= LRangle(9,:);
% stackData(2,5,:)= UBMut(10,:);

plotBarStackGroups(stackData, {'E13.5','E15.5','E17.5'})


VolumeMeanMut = [0.018 0.012 0.004 0.005 0.003;0 0.047 0.038 0.069 0.04];

AreaMeanMut = [0.85 0.65 0.34 0.44 0.32;0 2.9 2.52 3.7 3.48];
chpinVMut = [3.9 3.7 0.92 0.57 0.45;0 18 7.34 16 11.8];
AngleMut = [52 71 88 84 75; 0 92 107 68 67];

bar(VolumeMeanMut, 'grouped')


names = categorical({'Mean model','Cdk13 MUT','Cdk13 MUT'...
    'Cdk13 MUT','Cdk13 MUT','Cdk13 MUT',...
    'Mean model','Tmem 107 MUT','Tmem 107 MUT','Tmem 107 MUT'});
hB=bar(VolumeMeanMut);          % use a meaningful variable for a handle array...
hT=[];              % placeholder for text object handles
for i=1:length(hB)  % iterate over number of bar objects
  hT=[hT,text(hB(i).XData+hB(i).XOffset,hB(i).YData,names(:,i), ...
          'VerticalAlignment','bottom','horizontalalign','center')];
end







Mutanidx = [0 0 0 0 0 1 1 1 1 0 1 0 0 0 0 1 1 1];
names = categorical({'Mean model E13.5','Cdk13 E13.5 MUTA','Cdk13 E13.5 MUTD'...
    'Cdk13 E13.5 ko165-7','Cdk13 E13.5 ko165-8',...
    'Mean model E15.5','Tmem 107 E15.5 MUT','Tmem 107 E15.5 null134-6','Tmem 107 E15.5 null134-7'});

hB=bar(Volume);          % use a meaningful variable for a handle array...
hT=[];              % placeholder for text object handles
for i=1:length(hB)  % iterate over number of bar objects
  hT=[hT,text(hB(i).XData+hB(i).XOffset,hB(i).YData,names(:,i), ...
          'VerticalAlignment','bottom','horizontalalign','center')];
end


bar(Volume)
% ylim([0 160])
ylabel('Volume [mm3]')
title('Volume of segmented choroid plexus')
% hold on
% xlim=get(gca,'xlim');
% plot(xlim,[90 90],'--','LineWidth',2)

x=names;
x=categorical(x,x,"Ordinal",1)
y=Angles;
map = colormap('jet');
[mmap,nmap] = size(map);
data_min = min(y);
data_max = max(y);


f= figure(1), hold on
for k = 1:length(y)
      h=bar(x(k),y(k));
      if y(k)<=90
          set(h, 'FaceColor', 'red') ;
      else 
          set(h, 'FaceColor', 'blue') ;
      end
    % Display the values as labels at the tips of the  bars. 
    xtips1 = h.XEndPoints;
    ytips1 = h.YEndPoints + 3;
    labels1 = string(h.YData);
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center')
end
xlim=get(gca,'xlim');
plot(xlim,[90 90],'--','LineWidth',2)
ylabel('Angle [°]')
title('Growth angle of choroid plexus into 4th ventricle')
hold off

%% Boxplot + hier. clustering

names = categorical({'Cdk13 sample 1 WT','Cdk13 sample 2 WT','Cdk13 sample 3 Mut',...
    'Cdk13 sample 4 Mut','Cdk13 sample 5 WT','Cdk13 sample 6 Mut','Tmem 107 sample 1 WT','Tmem 107 sample 2 Mut',...
    'Tmem 107 sample 3 WT','Tmem 107 sample 4 WT','Tmem 107 sample 5 WT',...
    'Tmem 107 sample 6 Mut','Tmem 107 sample 7 Mut'});

volume = [0.0322 0.0180 0.0117 0.0042 0.0368 0.0334 0.0480 0.0393 0.0380 0.0473 0.0545 0.0690 0.0403];
for i=1:length(volume)
    volume(i)= nthroot((volume(i)*(3/4)/pi), 3);
end


area = [1.590 0.904 0.648 0.343 2.816 2.717 3.107 2.522 2.454 2.967 3.062 3.702 3.475];
for i=1:length(area)
    area(i)= sqrt(area(i)/(4*pi));
end


figure
subplot 121
names = categorical({'Cdk13 sample 1 WT','Cdk13 sample 2 WT','Cdk13 sample 3 Mut',...
    'Cdk13 sample 4 Mut','Cdk13 sample 5 WT','Cdk13 sample 6 Mut'});
bar(names,volume(1:6))
ylim([0.06,max(volume(1:6))+0.01])
ylabel('Radius [mm]')
subplot 122
names = categorical({'Tmem 107 sample 1 WT','Tmem 107 sample 2 Mut',...
    'Tmem 107 sample 3 WT','Tmem 107 sample 4 WT','Tmem 107 sample 5 WT',...
    'Tmem 107 sample 6 Mut','Tmem 107 sample 7 Mut'});
bar(names,volume(7:end))
ylim([0.2,max(volume(7:end))+0.01])
ylabel('Radius [mm]')
% subplot 212
% bar(names,area)
% ylim([0,max(area)+0.1])
% ylabel('Radius [mm]')
% title('Surface area of segmented models converted into a radius of sphere with equal area')
% text(0.02,0.98,'B','Units', 'Normalized', 'VerticalAlignment', 'Top','FontSize',20)

names = categorical({'Cdk13 E13 WT 1','Cdk13 E13 WT 2','Cdk13 E13 Mut 1',...
    'Cdk13 E13 Mut 2','Cdk13 E15 WT 1','Cdk13 E15 Mut 2','Tmem 107 E15 WT 1'...
    'Tmem 107 E15 WT 2','Tmem 107 E15 WT 3','Tmem 107 E15 WT 4',...
    'Tmem 107 E15 Mut 3','Tmem 107 E15 Mut 2','Tmem 107 E15 Mut 1',});
volume = [0.0322 0.018 0.0117 0.0042 0.0368 0.0334 0.0480 0.0380 0.0473 0.0545 0.0393 0.069 0.0403];

% box plot
volume_13_ckd13=volume(1:4);
names_13 = names(1:4)
volume_13_ckd13=[mean(volume(1:2)); mean(volume(2:3))];

figure
subplot 131
X=categorical({'WT: mean volume','MUT: mean volume'})
bar(X,volume_13_ckd13)
ylabel('Volume [mm3]')
title('CDK13: E13')
% ylim([0 0.25])
text(0.02,0.98,'A','Units', 'Normalized', 'VerticalAlignment', 'Top','FontSize',20)
subplot 132
volume_15_cdk13=volume(5:6);
volume_15_ckd13=[volume(5); volume(6)];
X=categorical({'WT','MUT'})
bar(X,volume_15_ckd13)
ylabel('Volume [mm3]')
% ylim([0 0.25])
title('CDK13: E15')
text(0.02,0.98,'B','Units', 'Normalized', 'VerticalAlignment', 'Top','FontSize',20)
subplot 133
volume_15_tmem=[mean(volume([7,8,9,10])); mean(volume([11, 12, 13]))];
X=categorical({'WT: mean volume','MUT: mean volume'})
bar(X,volume_15_tmem)
ylabel('Volume [mm3]')
% ylim([0 0.25])
title('Tmem 107: E15')
text(0.02,0.98,'C','Units', 'Normalized', 'VerticalAlignment', 'Top','FontSize',20)

%mean volume
mean_13_wt = mean(volume((1:2)));
std_13_wt = std(volume((1:2)));
mean_13_mut = mean(volume(2:3));
std_13_mut = std(volume(2:3));
mean_15_wt = mean(volume([5,7,9,10,11]));
std_15_wt = std(volume([5,7,9,10,11]));
mean_15_mut = mean(volume([6,8, 12, 13]));
std_15_mut = std(volume([6,8, 12, 13]));


