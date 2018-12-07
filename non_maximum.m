function [ output_I ] = non_maximum( input_I , thres , range )

output_I = zeros( size( input_I ) );
half_range = ceil( range/2 );

[ x_pos , y_pos ] = find( input_I > thres );
index = find( x_pos < half_range | x_pos > size( input_I , 1 ) - half_range + 1 | y_pos < half_range | y_pos > size( input_I , 2 ) - half_range + 1 );  
x_pos( index ) = [];
y_pos( index ) = [];

for i = 1 : length( x_pos )
    
    region = input_I( x_pos(i) - half_range + 1 : x_pos(i) + half_range - 1 , y_pos(i) - half_range + 1 : y_pos(i) + half_range - 1 );
	region = sort( region(:) , 'descend' );    

	if region( 1 ) == input_I( x_pos(i) , y_pos(i) ) & region( 1 ) > region( 2 )
        output_I( x_pos(i) , y_pos(i) ) = 1;
    end
    
end

end
