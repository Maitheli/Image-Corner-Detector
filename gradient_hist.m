function [ hist_I ] = gradient_hist( I , mag_seg , ang_seg )

% compute the magnitude 
[ Ix , Iy ] = gradient( double( rgb2gray( I ) ) );
mag_I = ( Ix.^2 + Iy.^2 ).^0.5;
mag_ind = zeros( size( I , 1 ) , size( I , 2 ) );
max_magitude = ( ( 255^2 + 255^2 )^0.5 ) / 4;  

for i = 1 : mag_seg
    tar_num = ( max_magitude / mag_seg ) * ( i - 1 );
    mag_ind( mag_I >= tar_num ) = i; 
end

% determine the orientation 
ang_I = atan2( Iy , Ix );
ang_I( ang_I < 0 ) = ang_I( ang_I < 0 ) + 2*pi;
ang_ind = zeros( size( I , 1 ) , size( I , 2 ) );

for i = 1 : ang_seg
    tar_num = ( 2*pi / ang_seg ) * ( i - 1 );
    ang_ind( ang_I >= tar_num ) = i; 
end

% compute the corresponding bin index
hist_I = ( mag_ind - 1 ) * ang_seg + ang_ind;

end
