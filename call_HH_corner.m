function [ R_A_cube , entropy_value , R_A_cell ] = call_HH_corner( hist_I , uni_scale , sigma )

% function call_HH_corner computes R(H), entropy, elements of the 2x2 matrix for each pixel per scale 
% input:
%     hist_I - histogram for each scale
%     uni_scale - scales 
%     sigma - size and standard deviation of gaussian kernel
% output:
%     R_A_cube - R(H) 
%     entropy_value 
%     R_A_cell - elements of the 2x2 matrix (stored as a cell array)

sig2 = sigma^2;
sig4 = sigma^4;
hsize = [ 2*round(3.5*sigma)+1 , 2*round(3.5*sigma)+1 ];    % the size of the gaussian kernel
H = fspecial( 'gaussian' , hsize , sigma*2 );               % generate the gaussian kernel

% for each scale
for sn = 1 : length( uni_scale )   
    
    [ x_size , y_size ] = size( hist_I{sn} );

    entropy_value{ sn } = zeros( x_size , y_size );
    HX_2 = zeros( x_size , y_size );     
    HY_2 = zeros( x_size , y_size );     
    HXY = zeros( x_size , y_size );      
    
    [ yy , xx ] = meshgrid( 1:y_size , 1:x_size );
    uni_hist = unique( hist_I{sn} );
    
    % for each histogram bin
    display( ['computing the histogram at scale ',num2str(uni_scale(sn)) ' ...'] );
    
    for i = 1 : length( uni_hist )
        temp_xx = xx;
        temp_yy = yy;
        total_arr = ones( x_size , y_size );

        temp_xx( hist_I{sn} ~= uni_hist( i ) ) = 0;
        temp_yy( hist_I{sn} ~= uni_hist( i ) ) = 0;
        total_arr( hist_I{sn} ~= uni_hist( i ) ) = 0;

        temp_xx = conv2( temp_xx , H , 'same' ); 
        temp_yy = conv2( temp_yy , H , 'same' );
        total_arr = conv2( total_arr , H , 'same' );

        % calculate the entropy values
        entropy_value{ sn } = entropy_value{ sn } - total_arr .* log( total_arr + eps );  
        
        % calculate 1/hk[I,x,y]
        total_arr = 1 ./ ( total_arr + eps );   
        
        HX_2 = HX_2 + total_arr .* ( temp_xx .^ 2 );
        HY_2 = HY_2 + total_arr .* ( temp_yy .^ 2 );
        HXY = HXY + total_arr .* ( temp_xx .* temp_yy );

    end

    R_A_cell{ sn }(:,:,1) = ( 2/sig2 - xx.^2/sig4 ) + ( 1/sig4 ) * HX_2;             % calculate (1,1) elements
    R_A_cell{ sn }(:,:,2) = ( - xx.*yy / sig4 ) + ( 1/sig4 ) * HXY;                  % calculate (1,2) (2,1) elements
    R_A_cell{ sn }(:,:,3) = ( 2/sig2 - yy.^2/sig4 ) + ( 1/sig4 ) * HY_2;             % calculate (2,2) elements
        
    R_A_cell{ sn }(:,:,1) = -1 * R_A_cell{ sn }(:,:,1);
    R_A_cell{ sn }(:,:,2) = -1 * R_A_cell{ sn }(:,:,2);
    R_A_cell{ sn }(:,:,3) = -1 * R_A_cell{ sn }(:,:,3);
    
    % compute the responses
    det_A = R_A_cell{ sn }(:,:,1) .* R_A_cell{ sn }(:,:,3) - R_A_cell{ sn }(:,:,2) .^ 2;
    trace_A = R_A_cell{ sn }(:,:,1) + R_A_cell{ sn }(:,:,3);
    R_A_cube{ sn } = det_A - 0.1 * trace_A .^ 2;

    % ignore the margin
    R_A_cube{ sn } = R_A_cube{ sn }( ceil(hsize(1)/2):end-floor(hsize(1)/2) , ceil(hsize(2)/2):end-floor(hsize(2)/2) );
    R_A_cube{ sn } = padarray( R_A_cube{ sn } , [ floor(hsize(1)/2) , floor(hsize(2)/2) ] );
    
	% ignore the margin
    entropy_value{ sn } = entropy_value{ sn }( ceil(hsize(1)/2):end-floor(hsize(1)/2) , ceil(hsize(2)/2):end-floor(hsize(2)/2) );
    entropy_value{ sn } = padarray( entropy_value{ sn } , [ floor(hsize(1)/2) , floor(hsize(2)/2) ] );
    
end
