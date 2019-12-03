function meanSig = radialDistSig(ROI)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

c = regionprops(ROI,'Centroid');
csize = size(c);
csize = csize(1);
if csize == 1
    c = c.Centroid;
else
    c = c(255).Centroid;
end

ROIsize = size(ROI);

d = [];

for i=1:ROIsize(1)
    for j=1:ROIsize(2)
        if ROI(i,j) ~= 0
            if (ROI(i+1,j+1) == 0 || ROI(i+1,j) == 0 || ROI(i+1,j-1) == 0 || ROI(i,j+1) == 0 || ROI(i,j-1) == 0 || ROI(i-1,j+1) == 0 || ROI(i-1,j) == 0 || ROI(i-1,j-1) == 0)
                d = [d;sqrt((i - c(1)).^2 + (j - c(2)).^2)];
            end
        end
    end
end

meanSig = [min(d); max(d); median(d); mean(d); std(d)];


end

