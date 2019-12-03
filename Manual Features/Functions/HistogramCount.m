function counts = HistogramCount(Slice,ROI,bins)
%HISTOGRAMCOUNT Summary of this function goes here
%   Detailed explanation goes here

counts = zeros(1,bins);

ROIsize = size(ROI);

for i=1:ROIsize(1)
    for j=1:ROIsize(2)
        if ROI(i,j) ~= 0
            x = ceil(Slice(i,j)*bins);
            if x == 0
                x = 1;
            end
            counts(x) = counts(x)  + 1;
        end
    end
end

end