function e = Ent(Slice,ROI)
%ENTROPY Summary of this function goes here
%   Detailed explanation goes here

ROIsize = size(ROI);

for i=1:ROIsize(1)
    for j=1:ROIsize(2)
        if ROI(i,j) == 0
            Slice(i,j) = 0;
        end
    end
end

e = entropy(Slice);

end

