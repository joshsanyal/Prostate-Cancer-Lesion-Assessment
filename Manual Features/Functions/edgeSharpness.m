function s = edgeSharpness(Slice, ROI)
%EDGESHARPNESS Summary of this function goes here
%   Detailed explanation goes here

[Gmag,~] = imgradient(Slice);
d = [];

ROIsize = size(ROI);

for i=1:ROIsize(1)
    for j=1:ROIsize(2)
        if ROI(i,j) ~= 0
            d = [d,Gmag(i,j)];
        end
    end
end

s = [min(d); max(d); median(d); mean(d); std(d)];

end