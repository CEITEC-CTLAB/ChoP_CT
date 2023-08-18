function [hausdorffDist] = PCsimilarity(region,FourthVentricle_reference)
%% Preprocessing - point cloud creation
FourthVentricle_reference = imbinarize(FourthVentricle_reference);
% region = imbinarize(region);

% crop data
[rowR1,rowR2,colR1,colR2] = cropBCG(FourthVentricle_reference);
FourthVentricle_reference = FourthVentricle_reference(rowR1:rowR2, colR1:colR2,:);
[rowR1,rowR2,colR1,colR2] = cropBCG(region);
region = region(rowR1:rowR2, colR1:colR2,:);


% Extract boundaries
boundary_model = bwperim(FourthVentricle_reference);
boundary_model_v = bwperim(region);

% convert to point cloud
[x, y, z] = ind2sub(size(boundary_model), find(boundary_model));
point_cloud = [x(:), y(:), z(:)];
[x_v, y_v, z_v] = ind2sub(size(boundary_model_v), find(boundary_model_v));
point_cloud_v = [x_v(:), y_v(:), z_v(:)];
num_points = size(point_cloud_v, 1);
num_points_to_keep = size(point_cloud, 1); 
if num_points_to_keep>10000
    num_points_to_keep = 8000;
    indices = randperm(num_points, num_points_to_keep);
    downsampled_point_cloud = point_cloud_v(indices, :);
    indices = randperm(size(point_cloud, 1), num_points_to_keep);
    point_cloud = point_cloud(indices, :);
else 
    indices = randperm(num_points, num_points_to_keep);
    downsampled_point_cloud = point_cloud_v(indices, :);
end 

point_cloud = pointCloud(point_cloud);
downsampled_point_cloud = pointCloud(downsampled_point_cloud);

% %% go back to image from point cloud
% slice_bw = zeros(size(FourthVentricle_reference));
% for n = 1:point_cloud.Count
%     xy = point_cloud.Location(n,:);
%     slice_bw(xy(1),xy(2),xy(3)) = 1;
% end
%% adjust scale of point clouds
centroid1 = mean(point_cloud.Location);
centroid2 = mean(downsampled_point_cloud.Location);
avgDist1 = mean(sqrt(sum((point_cloud.Location - centroid1).^2, 2)));
avgDist2 = mean(sqrt(sum((downsampled_point_cloud.Location - centroid2).^2, 2)));

scaleFactor = avgDist1 / avgDist2;
scaledPtCloud2 = pointCloud(downsampled_point_cloud.Location * scaleFactor);
downsampled_point_cloud = scaledPtCloud2;

%tform = pcregistericp(moving,fixed)
tform = pcregistericp(downsampled_point_cloud,point_cloud,Extrapolate=true,MaxIterations=1000,Tolerance=[1e-6, 1e-6]);

% [~,movingReg] = pcregistericp(downsampled_point_cloud,point_cloud,Metric="planeToPlane");
ptCloud2Registered = pctransform(downsampled_point_cloud, tform);
% figure;pcshow(ptCloud2Registered) 
% figure;pcshow(point_cloud) 
% figure;pcshow(downsampled_point_cloud) 

% Compute Hausdorff Distance
coords1 = point_cloud.Location;
coords2 = ptCloud2Registered.Location;

% Compute pairwise distances between points
distances = pdist2(coords1, coords2);
forwardHausdorff = max(min(distances, [], 2));
reverseHausdorff = max(min(distances, [], 1));
hausdorffDist = max(forwardHausdorff, reverseHausdorff);


% Compute the Hausdorff distance
% hausdorffDist = max(max(distances));

disp(['Hausdorff distance: ' num2str(hausdorffDist)]);

distances = sqrt(sum((point_cloud.Location - ptCloud2Registered.Location).^2, 2));
rmse = sqrt(mean(distances.^2));
disp(['RMSE: ' num2str(rmse)]);

%% figure
% pcshowpair(ptCloud2Registered,point_cloud,VerticalAxis="Y",VerticalAxisDir="Down")
% pcshowpair(downsampled_point_cloud,point_cloud,VerticalAxis="Y",VerticalAxisDir="Down")
end