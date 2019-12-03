%% Create Heatmap

for i = 56:57
    numSlices = length(Patient(i).ADC);
    
    startNum = 1;
%     if (i == 20)
%         startNum = 2;
%     end
    for ii = startNum:numSlices
        
        slice = adapthisteq(Patient(i).ADC(ii).Slice);
        
        heatmap = zeros(256,256);
        heatmap2 = zeros(256,256);
        
        xLeft = 64;
        yTop = 64;
        xRight = 192;
        yBottom = 192;
        
        for x = xLeft:xRight
           disp([int2str(i), ' ', int2str(ii), ' ', int2str(x)])
            for y = yTop:yBottom
                Predict = predict(EdgeADCProstateNet,slice(x-7:x+7,y-7:y+7));
                heatmap(x,y) = Predict(2);
                Predict2 = predict(EdgeNewADCProstateNet,slice(x-14:x+14,y-14:y+14));
                heatmap2(x,y) = Predict2(2);
            end
        end
        Patient(i).ADC(ii).ProstateHeatmap = heatmap;
        Patient(i).ADC(ii).EdgeProstateHeatmap = heatmap2;
        Patient(i).ADC(ii).CombinedProstateHeatmap = (heatmap+heatmap2)/2;
    end
end
%% Heatmap Overlay

patient = 74;
sliceNum = 2;

% Seg = bwboundaries(Patient(patient).ADC(sliceNum).PROI);

figure,
imshow(Patient(patient).ADC(sliceNum).CombinedProstateHeatmap);

figure,
imshowpair(Patient(patient).ADC(sliceNum).Slice,Patient(patient).ADC(sliceNum).CombinedProstateHeatmap, 'scaling', 'none');
% hold on
% for k = 1:length(Seg)
%     boundary = Seg{k};
%     plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
% end

%% 
for patient = 33:33
    disp(patient)
    for sliceNum = 1:min(length(Patient(patient).ADC),length(Patient(patient).DWI))

        centroid = regionprops(ones(256,256),Patient(patient).ADC(sliceNum).CombinedProstateHeatmap,'weightedcentroid');
        if (length(centroid) == 255)
           x = round(centroid(255).WeightedCentroid(1));
           y = round(centroid(255).WeightedCentroid(2));
        else
           x = round(centroid.WeightedCentroid(1));
           y = round(centroid.WeightedCentroid(2));
        end

        Mask = Patient(patient).DWI(sliceNum).CombinedPROI;

        newROI = activecontour(Patient(patient).ADC(sliceNum).CombinedProstateHeatmap,Mask,3,'Chan-Vese');
        windowSize = 20;
        kernel = ones(windowSize) / windowSize ^ 2;
        blurryImage = conv2(single(newROI), kernel, 'same');
        binaryImage = blurryImage > 0.5;

        Patient(patient).ADC(sliceNum).CombinedPROI = binaryImage;
        
    end
end

%% Seg on Slice

patient = 52;
sliceNum = 1;

Seg = bwboundaries(Patient(patient).ADC(sliceNum).CombinedPROI);
seg = bwboundaries(Patient(patient).ADC(sliceNum).ROI);

figure,
imshow((Patient(patient).ADC(sliceNum).Slice));
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end
for k = 1:length(seg)
    boundary = seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

%% 

for i = 73:77
    numSlices = length(Patient(i).ADC);
    for ii = 1:numSlices
        centroid = regionprops(ones(256,256),Patient(i).ADC(ii).ProstateHeatmap,'weightedcentroid');
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

        newROI = activecontour(Patient(i).ADC(ii).ProstateHeatmap,Mask,40,'Chan-Vese');
        windowSize = 10;
        kernel = ones(windowSize) / windowSize ^ 2;
        blurryImage = conv2(single(newROI), kernel, 'same');
        binaryImage = blurryImage > 0.5;
        
        Patient(i).ADC(ii).SmallPROI = binaryImage;
    end
end


diceScores = [];

for i = 73:77
    numSlices = length(Patient(i).ADC);
    for ii = 1:numSlices
        diceScores = [diceScores,dice(Patient(i).ADC(ii).SmallPROI,logical(Patient(i).ADC(ii).PROI))];
    end
end

mean(diceScores)
std(diceScores)