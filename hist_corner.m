function hist_corner( input_path , save_path , mode )
% Histogram-based interest point detectors
% By Wei-Ting Lee (2009)
%
% Input :
%   input_path - the path of the input image
%   save_path - the path of the result file
%   mode - 1 for color histogram, 2 for oriented gradient histogram

% parameters
uni_scale = (2^0.5).^[2:9];   % scales
sigma = 2;                    % the size and the standard deviation of gaussian kernel

if mode == 1       % color   
    
    p1 = 32;       % number of histogram bins
    thres_1 = 70;  % threshold for smaller scales
    thres_2 = 30;  % threshold for larger scales
    
elseif mode == 2    % gradient 
    
    mag_seg = 8;    % quantization of magnitude 
    ang_seg = 8;    % quantization of orientation
    thres_1 = 120;  % threshold for smaller scales
    thres_2 = 50;   % threshold for larger scales
    
end


% pre-processesing 
Input_I = pre_image( input_path );

% compute the histogram for each scale
for sn = 1 : length( uni_scale ) 
    I = imresize( Input_I , sigma/uni_scale(sn) );
    
    if mode == 1
        % color histogram
        hist_I{ sn } = color_hist( I , p1 );         
    elseif mode == 2
        % oriented gradient histogram
        hist_I{ sn } = gradient_hist( I , mag_seg , ang_seg );
    end 
end

[ R_A_cube , entropy_value , R_A_cell ] = call_HH_corner( hist_I , uni_scale , sigma ); 

% extract interest points
new_raw_keypoints = select_keypoint( R_A_cube , entropy_value , R_A_cell , uni_scale , sigma , thres_1 , thres_2 ); 

% compute the descriptors of interest points and save them as .mat files
% for computing the repeatability and the matching score
% (for Linux only)
save_mat_data( save_path , input_path , new_raw_keypoints );

end

