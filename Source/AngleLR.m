function AngleLR(ymatrix1)
%CREATEFIGURE1(ymatrix1)
%  YMATRIX1:  bar matrix data

%  Auto-generated by MATLAB on 17-Apr-2023 13:43:35

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to bar
bar1 = bar(ymatrix1);
set(bar1(1),...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922]);
set(bar1(2),'FaceColor','none','BarWidth',1);

% Create ylabel
ylabel('Angle [°]');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.514285714285714 17.4857142857143]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',16,'XTick',[3 9 15],'XTickLabel',...
    {'E13.5','E15.5','E17.5'});