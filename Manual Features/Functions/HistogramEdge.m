function counts = HistogramEdge(Slice,ROI,bins)
%HISTOGRAMEDGE Summary of this function goes here
%   Detailed explanation goes here

ROIsize = size(ROI);
counts = zeros(1,bins);

for i=1:ROIsize(1)
    for j=1:ROIsize(2)
        if ROI(i,j) ~= 0
            if (ROI(i+1,j+1) == 0 || ROI(i+1,j) == 0 || ROI(i+1,j-1) == 0 || ROI(i,j+1) == 0 || ROI(i,j-1) == 0 || ROI(i-1,j+1) == 0 || ROI(i-1,j) == 0 || ROI(i-1,j-1) == 0)
                x = ceil(Slice(i,j)*bins);
                if x == 0
                    x = 1;
                end
                counts(x) = counts(x)  + 1;
            end
        end
    end
end

end

