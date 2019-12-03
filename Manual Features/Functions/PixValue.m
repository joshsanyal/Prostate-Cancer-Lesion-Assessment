function proportion = PixValue(Slice,ROI)
%PIXVALUE Summary of this function goes here
%   Detailed explanation goes here

ROIsize = size(ROI);
proportion = [];

d = [];

for i = 1:ROIsize(1)
    for j = 1:ROIsize(2)
        if ROI(i,j) ~= 0
            d = [d; Slice(i,j)];
        end
    end
end

proportion = sum(d>(0.5))/length(d);

end

