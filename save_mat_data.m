function save_mat_data( save_path , input_path , new_raw_keypoints )

% input:
%     save_path - the result file
%     input_path - the input image file
%     new_raw_keypoints - parameters of all interest points

    fid = fopen( save_path , 'w' );
    
    fprintf( fid , '%f\n' , 1.0 );
    fprintf( fid , '%d\n' , size( new_raw_keypoints , 1 ) );
    for i = 1 : size( new_raw_keypoints , 1 )
        data = new_raw_keypoints(i,:);
        fprintf( fid , '%f ' , data );
        fprintf( fid , '\n' );
    end
    fclose(fid);
    
    % use compute_descriptors.ln downloaded from
    % http://www.robots.ox.ac.uk/~vgg/research/affine/descriptors.html 
    % to get the descriptors of interest points
    % (Linux only)
    eval([ '!./compute_descriptors.ln -sift -i ' , input_path , ' -p1 ' , save_path , ' -o1 ' , save_path ]);
    
end
