function [ region_map ] = gen_rect_region( size_y, size_x, ...
    region_count, colour_count)
%GEN_RECT_REGION Generate random rectangular region
%   This is the first step for creating the Mondrian world. We create
%   overlapping rectangular regions
%       size_y - the number of rows that the resulting matrix has
%       size_x - the number of columns that the resulting matrix has
%       region_count - the number of rectangle to draw
%       colour_count - the number of colour used in this Mondrian map. 

%% Initialise background with a random colour
region_map = zeros(size_y, size_x);
region_map(:) = randi(colour_count);

% Minimimum size for individual region
min_size_ratio = 0.10;
y_min_size = round(size_y * min_size_ratio);
x_min_size = round(size_x * min_size_ratio);

%% Draw individual regions, fill with random colour
for i = 1:region_count
    start_y = randi(size_y - y_min_size);
    start_x = randi(size_x - x_min_size);
    end_y = randi([start_y + y_min_size size_y]);
    end_x = randi([start_x + x_min_size size_x]);
    region_map(start_y:end_y, start_x:end_x) = randi(colour_count);
end

end
