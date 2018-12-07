function demo1()
% Using "hist_corner.m" to detect histogram-based interest points
%
% The function "display_features.m" and the test images are downloaded from 
% http://www.robots.ox.ac.uk/~vgg/research/affine/

% color
disp('--- Detecting interest points using color histograms ---')
input_path = 'image/wall/img1.ppm';
output_path = 'color_result/wall_img1.mat';
tic
hist_corner( input_path , output_path , 1 );
toc
figure; display_features( output_path , input_path , 1 , 1 ); 
set(gcf, 'name', 'color');
drawnow

% oriented gradient
disp('--- Detecting interest points using oriented gradient histograms ---')
input_path = 'image/wall/img1.ppm';
output_path = 'gradient_result/wall_img1.mat';
tic
hist_corner( input_path , output_path , 2 );
toc
figure; display_features( output_path , input_path , 1 , 1 ); 
set(gcf, 'name', 'gradient');
drawnow

end
