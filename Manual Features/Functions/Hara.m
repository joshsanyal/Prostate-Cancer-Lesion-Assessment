function [x] = Hara(Slice,ROI,width)
%HARA Summary of this function goes here
%   Detailed explanation goes here
ROIsize = size(ROI);

paddedROI = padarray(ROI,width);
h = zeros(ROIsize(2)+2*width, width);
paddedROI = horzcat(h, paddedROI, h);

PaddedROIsize = size(paddedROI);

for i = 1 + width:PaddedROIsize(1)-width 
    for j = 1 + width:PaddedROIsize(2)-width
        sum = 0;
        for a = i-width:i+width
            for b = j-width:j+width
                if (sqrt((i-a)*(i-a)+(j-b)*(j-b)) <= width)
                    sum = sum + paddedROI(a,b);
                end
            end
        end
        if (sum > 0) 
            ScaledROI(i-width, j-width) = 255;
        else
            ScaledROI(i-width, j-width) = 0;
        end
    end
end

ScaledROIsize = size(ScaledROI);

for i=1:ScaledROIsize(1)
    for j=1:ScaledROIsize(2)
        if ScaledROI(i,j) == 0
            Slice(i,j) = 0;
        end
    end
end

x = Haralick(Slice);

end

