function [ hist_I ] = color_hist( I , p1 )

I = double( I );
hist_I = floor( I(:,:,1) / p1 ) * (256/p1)^2 + floor( I(:,:,2) / p1 ) * (256/p1) + floor( I(:,:,3) / p1 ) + 1;

end
