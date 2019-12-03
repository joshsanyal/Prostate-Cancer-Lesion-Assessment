function mean = InsM(Slice, ROI)
%INSM Summary of this function goes here
%   Detailed explanation goes here

ROIsize = size(ROI);
sum = 0;
counter = 0;

for i = 1:ROIsize(1)
    for j = 1:ROIsize(2)
        if ROI(i,j) ~= 0
            counter = counter + 1;
            sum = sum + Slice(i,j);
        end
    end
end

mean = sum/counter;

end

