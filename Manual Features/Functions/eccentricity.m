function e = eccentricity(ROI)
%ELLI Summary of this function goes here
%   Detailed explanation goes here

stats = regionprops(ROI,'Eccentricity');
e = stats.Eccentricity;

end

