# mondrian_map_generator
This is useful for generating test images for shadow removal algorithms

	%GEN_MONDRIAN Generate a mondrian image, illuminated with two spectra
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

You will need to import the spectral data, camera response curve, and reflectance
from:
  - http://www.cs.sfu.ca/~colour/data/colour_constancy_synthetic_test_data/index.html
  - http://kobus.ca/research/data/colour_constancy_synthetic_test_data/

You can use ''grep -v \# $FILENAME | grep .'' to remove comments
