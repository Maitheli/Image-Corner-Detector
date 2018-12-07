function [ I ] = pre_image( input_path )

% Input : 
%   input_path - the input image file
% Output :
%   I - the image I after pre-processing 

I = imread( input_path );

% gray image format --> color image format    
if ndims( I ) == 2
    I = repmat( I , [ 1 , 1 , 3 ] );
end

% histogram equalization for each channel
I( : , : , 1 ) = histeq( I( : , : , 1 ) );
I( : , : , 2 ) = histeq( I( : , : , 2 ) );
I( : , : , 3 ) = histeq( I( : , : , 3 ) );

% gaussian smoothing for each channel
I = im2double( I );
H = fspecial( 'gaussian' , [5 5] , 1.0 );
I( : , : , 1 ) = conv2( I( : , : , 1 ) , H , 'same' );
I( : , : , 2 ) = conv2( I( : , : , 2 ) , H , 'same' );
I( : , : , 3 ) = conv2( I( : , : , 3 ) , H , 'same' );
I = im2uint8( I );

end
