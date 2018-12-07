function [ new_raw_keypoints ] = select_keypoint( R_A_cube , entropy_value , R_A_cell , uni_scale , sigma , thres_1 , thres_2 )

% Input :
%   R_A_cube - the response R(H) 
%   entropy_value - 
%   R_A_cell - the elements of the 2x2 matrix (stored a cell array)
%   uni_scale - scales
%   sigma - determines the range of nonmaximum supression
%   thres_1 - threshold of smaller scales
%   thres_2 - threshold of larger scales
% Output :
%   new_raw_keypoints - parameters of all interest points

new_raw_keypoints = [];

% select interest points at each scale
for sn = 1 : length( uni_scale )

    if uni_scale( sn ) <= 5
        thres_num = thres_1;
    else
        thres_num = thres_2;
    end

    % decide the threshold at this scale
    thres = R_A_cube{ sn } .*  entropy_value{ sn };
    thres = sort( thres(:) , 'descend' );
    thres = thres( floor( length( thres ) / thres_num ) );

    % decide the nonmaximum supression range at this scale
    range = 2*round( 1.5*sigma )+1;

    % the positions of interest points at this scale is marked by 1 in the point_select array  
    point_select = non_maximum( R_A_cube{ sn } .* entropy_value{ sn } , thres , range );

    % record x, y, a, b, c parameters for each interest points in the new_raw_keypoints array
    [ x_pos , y_pos ] = find( point_select == 1 );       
    for i = 1 : length( x_pos )

%         sigma1 = R_A_cell{ sn }( x_pos(i) , y_pos(i) , 1 ).^0.5;
%         sigma2 = R_A_cell{ sn }( x_pos(i) , y_pos(i) , 3 ).^0.5;
%         Rho = R_A_cell{ sn }( x_pos(i) , y_pos(i) , 2 ) / (sigma1*sigma2);

        sigma1 = ( -1 * R_A_cell{ sn }( x_pos(i) , y_pos(i) , 1 ) ).^0.5;
        sigma2 = ( -1 * R_A_cell{ sn }( x_pos(i) , y_pos(i) , 3 ) ).^0.5;
        Rho = ( -1 * R_A_cell{ sn }( x_pos(i) , y_pos(i) , 2 ) ) / (sigma1*sigma2);

        % enlarge sigma1 and sigma2 according to the scale size
        temp = round(3.5*uni_scale(sn)) / ( (sigma1+sigma2)/2 );
        sigma1 = sigma1*temp;
        sigma2 = sigma2*temp;

        a = 1 / ( sigma1^2*(1-Rho^2) );
        b = - Rho / ( sigma1*sigma2*(1-Rho^2) );
        c = 1 / ( sigma2^2*(1-Rho^2) );

        new_raw_keypoints = [ new_raw_keypoints ; y_pos(i)*(uni_scale(sn)/sigma) , x_pos(i)*(uni_scale(sn)/sigma) , a , b , c ];

    end

end


end
