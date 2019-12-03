function [image] = imNorm(image)
%IMNORM Summary of this function goes here
%   Detailed explanation goes here
image = image - min(image(:)) ;
image = image / max(image(:)) ;
end

