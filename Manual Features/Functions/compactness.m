function c = compactness(ROI)
%COMPACTNESS Summary of this function goes here
%   Detailed explanation goes here

stats = regionprops(ROI,'Perimeter','Area');
csize = size(stats);
csize = csize(1);
if csize == 1
    edgeLength = stats.Perimeter;
    area = stats.Area;
else
    edgeLength = stats(255).Perimeter;
    area = stats(255).Area;
end

c = 4 * pi * area / (edgeLength * edgeLength);

end
