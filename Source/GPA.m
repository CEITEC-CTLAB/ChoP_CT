function d = GPA(myStructure,MM)
numberofmodels = length(fieldnames(myStructure));
names = fieldnames(myStructure);
numberoflandmarks = size(myStructure.(names{1}),1);


points = zeros([numberofmodels, 3, numberoflandmarks]);
C_hat = zeros([3 numberoflandmarks]);



for i= 1:numberoflandmarks
    firstRows = zeros(numel(names),3);
    % Iterate through each field and extract the first row
    for k = 1:numel(names)
        currentField = myStructure.(names{k});
        firstRows(k,:) = currentField(i, :);
    end
    points(:,:,i) = firstRows;
    C_hat(:,i) = MM(i,:);
end



%% Generalized Procrustes analysis 
% Compute optimal mean face C_hat
% Initialize the initial centroid C as the first image

% Translation 
no_points = size(points, 3);  
datasize = size(points, 1); 

points_mean = mean(points, 3); 
points_mean = repmat(points_mean, [1, 1, no_points]); 

points = points - points_mean; 

N = 1000;                                % Maximum number of iterations 
epsln = 0.01;                           % Quality Parameter 
C_hat = squeeze(points(1, :, :));
Error_plot = zeros(N, 1); 
Error_plot(1) = 1; 
iter = 1; 
while (Error_plot(iter) > epsln && iter < N) 
    C = C_hat; 
    % Compute similarity transformations between the images and mean shape 
    C_hat = zeros(3, no_points); 
    for i = 1:datasize
        X = squeeze(points(i, :, :)); 
        s = sqrt(sum(C(:).^2) / sum(X(:).^2)); % This will give us the relative scale 
        M = C*X';
        R = M*(M'*M)^(-0.5);                   % 
        % Fitting a similarity transform between the target shape and
        % original shape 
        C_hat = C_hat + s*R*X; 
    end
    C_hat = C_hat/datasize; 
    C_hat = C_hat - repmat(mean(C_hat, 2), [1, no_points]); 
    iter = iter + 1; 
    Error_plot(iter) = norm(C - C_hat); 
    disp(Error_plot(iter)); 
end
Error_plot(iter+1:end) = []; 


%% Translate the points with optimal centre 

points_transformed = points; 

for i = 1:numberofmodels
    X = squeeze(points(i, :, :)); 
    s = sqrt(sum(C_hat(:).^2) / sum(X(:).^2)); 
    M = C_hat*X';
    R = M*(M'*M)^(-0.5); 
    points_transformed(i, :, :) = s*R*squeeze(points(i, :, :)); 
end

%% Procrustes distances
%The Procrustes distance is the sum of squared differences between sample and mean shape.
%mean shape = C_hat
d=[];

%tansformed_points = transformed points along mean shape

for i=1:size(points_transformed,1)
    WT1 = points_transformed(i,:,:);
    WT1 = reshape(WT1,3,6);
    X=[];
    for j = 1:6
    X= [X; norm(C_hat(:,j) - WT1(:,j))];
    end
    ssd = sum(X(:).^2);
    d=[d ssd];    
end

end