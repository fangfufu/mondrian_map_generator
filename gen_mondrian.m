function [ mondrian_map, edge_map ] = gen_mondrian( size_y, size_x, ...
    region_count, bright_spectra, shadow_spectra, reflectance, ...
    camera_response)
% GEN_MONDRIAN Generate a mondrian image - with the ability to add shadow
%   Parameter list:
%       size_y - the number of rows that the resulting matrix has
%       size_x - the number of columns that the resulting matrix has
%       region_count - the number of rectangle to draw (they might overlap)
%       bright_spectra - the spectra for the lit region
%       shadow_spectra - the spectra for the shadowed region
%       reflectance - the material's reflectance distribution
%       device_respone - the response curve of the imaging device
%
%   Variable dimensions:
%       bright_spectra and shadow spectra:
%           n-vector, where 
%           - n is readings at individual bands, 
%       device_respones:
%           n x 3 matrices, where 
%           - n is readings at individual bands
%       reflectance:
%           n x o matrices, where 
%           - n is readings at individual bands
%           - o is the number of materials.
%


%% Generate the region map
colour_count = size(reflectance, 2);
region_map = gen_rect_region( size_y, size_x, region_count, colour_count);

% colour table, the lower part is the bright colour, the upper part is the
% shadowed colour. 
c_table = zeros(size(reflectance, 2)*2, 3);

% we basically add the shadow map onto the region map, so the shadowed
% colour will be indexed
shadow_map = gen_shadow_map(size_y, size_x) * colour_count;
edge_map = edge(shadow_map, 'canny');
region_map = region_map + shadow_map;

%% Precompute colours


for i = 1:colour_count
    c_table(i,:) = gen_colour(bright_spectra, reflectance(:,i), camera_response);
end

for i = colour_count+1 : colour_count*2
    c_table(i,:) = gen_colour(shadow_spectra, reflectance(:,i-colour_count), camera_response);
end

%% Create a new matrix, fill it with colour
% Three different colour channels
CR = zeros(size(region_map));
CG = CR;
CB = CG;

for i = 1:2*colour_count
    CR(region_map == i) = c_table(i, 1);
    CG(region_map == i) = c_table(i, 2);
    CB(region_map == i) = c_table(i, 3);
end

mondrian_map = cat(3, CR, CG, CB);
% Regularise output
mondrian_map = mondrian_map./max(mondrian_map(:));

end

function [ region_map ] = gen_shadow_map( size_y, size_x )
%GEN_SHADOW_REGION_MAP Generate a map containing a single shadowed region

%% Initialise background with a random colour
region_map = zeros(size_y, size_x);

% Minimimum size for individual region
min_size_ratio = 0.10;
y_min_size = round(size_y * min_size_ratio);
x_min_size = round(size_x * min_size_ratio);

start_y = randi(size_y - y_min_size);
start_x = randi(size_x - x_min_size);
end_y = randi([start_y + y_min_size size_y]);
end_x = randi([start_x + x_min_size size_x]);
region_map(start_y:end_y, start_x:end_x) = 1;

end

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

function [ d ] = gen_colour( E, S, D )
%GEN_COLOUR Generate a colour reading
%   Generate a colour reading, given spectral distribution, surface
%   reflectance, and device response curve
%
%   Parameters:
%       E: Spectral distribution
%       S: Surface reflectance
%       D: Device response curve
%
%   Formulae and notation follows "The maximum ignorance with positivity"
C = E.*S;
d = D' * C;
end



