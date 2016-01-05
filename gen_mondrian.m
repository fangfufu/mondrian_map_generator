function [ mondrian_map ] = gen_mondrian( size_y, size_x, ...
    region_count, bright_spectra, shadow_spectra, reflectance, ...
    camera_response)
%GEN_MONDRIAN Generate a mondrian image - with the ability to add shadow
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

% Regularise data input
% bright_spectra = bright_spectra ./ max(bright_spectra(:));
% reflectance = reflectance ./ max(reflectance(:));
% camera_response = camera_response ./ max(camera_response(:));
% NOTE: we need the dark spectra here too!

%% Generate the region map
colour_count = size(reflectance, 2);
region_map = gen_rect_region( size_y, size_x, region_count, colour_count);

%% Precompute colours
% bright colour table
bc_table = zeros(size(reflectance, 2), 3);
for i = 1:colour_count
    bc_table(i,:) = gen_colour(bright_spectra, reflectance(:,i), camera_response);
    % NOTE: we need to add the dc table here. 
end

%% Create a new matrix, fill it with colour
% Three different colour channels
CR = zeros(size(region_map));
CG = CR;
CB = CG;

for i = 1:colour_count
    CR(region_map == i) = bc_table(i, 1);
    CG(region_map == i) = bc_table(i, 2);
    CB(region_map == i) = bc_table(i, 3);
end

mondrian_map = cat(3, CR, CG, CB);
mondrian_map = mondrian_map./max(mondrian_map(:));

end

