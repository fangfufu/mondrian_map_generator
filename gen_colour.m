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

