%% Create Heatmap

for i = 45:57
    numSlices = length(Patient(i).DWI);
    if (i == 45)
        x = 2;
    else
        x = 1;
    end
    for ii = x:numSlices
        
        slice = adapthisteq(Patient(i).DWI(ii).Slice);
        
        heatmap = zeros(256,256);
        heatmap2 = zeros(256,256);
        
        xLeft = 64;
        yTop = 64;
        xRight = 192;
        yBottom = 192;
        
        for y = xLeft:xRight
           disp([int2str(i), ' ', int2str(ii), ' ', int2str(y)])
            for x = yTop:yBottom
                Predict = predict(SmallDWIProstateNet,slice(x-7:x+7,y-7:y+7));
                heatmap(x,y) = Predict(2);
                Predict2 = predict(LargeDWIProstateNet,slice(x-14:x+14,y-14:y+14));
                heatmap2(x,y) = Predict2(2);
            end
        end
        Patient(i).DWI(ii).ProstateHeatmap = heatmap;
        Patient(i).DWI(ii).EdgeProstateHeatmap = heatmap2;
        Patient(i).DWI(ii).CombinedProstateHeatmap = (heatmap+heatmap2)/2;
    end
end
%% Heatmap Overlay

patient = 76;
sliceNum = 2;

figure,
imshow(Patient(patient).DWI(sliceNum).CombinedProstateHeatmap);
figure,
imshowpair(Patient(patient).DWI(sliceNum).Slice,Patient(patient).DWI(sliceNum).CombinedProstateHeatmap, 'scaling', 'independent');


%% Chan-Vese
for i = 76:76
    disp(i)
    numSlices = length(Patient(i).DWI);
    for ii = 2:2

        maxPix = 0;
        for a = 16:241
            for b = 16:241
                sumPix = sum(sum(Patient(i).DWI(ii).CombinedProstateHeatmap(a-4:a+4,b-5:b+5)));
                if (sumPix > maxPix)
                    x = a;
                    y = b;
                    maxPix = sumPix;
                end
            end
        end
        
        Mask = zeros(256,256);
        for a = x-4:x+5
            for b = y-4:y+5
                Mask(a,b) = 1;
            end
        end

        newROI = activecontour(Patient(i).DWI(ii).CombinedProstateHeatmap,Mask,45,'Chan-Vese');
        windowSize = 10;
        kernel = ones(windowSize) / windowSize ^ 2;
        blurryImage = conv2(single(newROI), kernel, 'same');
        binaryImage = blurryImage > 0.5;
        
        Patient(i).DWI(ii).CombinedPROI = binaryImage;
    end
end

%% Examine Seg
patient = 76;
sliceNum = 2;


imagesc(Patient(patient).DWI(sliceNum).CombinedProstateHeatmap);

newSeg = bwboundaries(Patient(patient).DWI(sliceNum).CombinedPROI);

hold on
for k = 1:length(newSeg)
    boundary = newSeg{k};
    plot(boundary(:,2), boundary(:,1), 'black', 'LineWidth', 2)
end

%% Raw Image

patient = 73;
sliceNum = 2;

Seg = bwboundaries(Patient(patient).DWI(sliceNum).PROI);

figure,
imshow(Patient(patient).DWI(sliceNum).Slice);
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

%% Dice Score

for i = 73:77
    numSlices = length(Patient(i).DWI);
    for ii = 1:numSlices
        centroid = regionprops(ones(256,256),Patient(i).DWI(ii).CombinedProstateHeatmap,'weightedcentroid');
        if (length(centroid) == 255)
           x = round(centroid(255).WeightedCentroid(1));
           y = round(centroid(255).WeightedCentroid(2));
        else
           x = round(centroid.WeightedCentroid(1));
           y = round(centroid.WeightedCentroid(2));
        end

        Mask = zeros(256,256);
        Mask(x,y) = 1;
        Mask(x-1,y) = 1;

        newROI = activecontour(Patient(patient).DWI(sliceNum).CombinedProstateHeatmap,Mask,40,'Chan-Vese');
        windowSize = 10;
        kernel = ones(windowSize) / windowSize ^ 2;
        blurryImage = conv2(single(newROI), kernel, 'same');
        binaryImage = blurryImage > 0.5;
        
        Patient(i).DWI(ii).CombinedPROI = binaryImage;
    end
end


diceScores = [];

for i = 73:77
    numSlices = length(Patient(i).DWI);
    for ii = 1:numSlices
        diceScores = [diceScores,dice(Patient(i).DWI(ii).CombinedPROI,logical(Patient(i).DWI(ii).PROI))];
    end
end

mean(diceScores)
std(diceScores)