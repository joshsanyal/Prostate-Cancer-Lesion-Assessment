%% Create Heatmap
% 17 5 needs to be run

for i = 45:57
    numSlices = length(Patient(i).T2);
    for ii = 1:numSlices
        
        slice = imresize(adapthisteq(Patient(i).T2(ii).Slice),1/2);
        
        heatmap = zeros(256,256);
        heatmap2 = zeros(256,256);
        
        xLeft = 64;
        yTop = 50;
        xRight = 192;
        yBottom = 192;
        
        for y = xLeft:xRight
           disp([int2str(i), ' ', int2str(ii), ' ', int2str(y)])
            for x = yTop:yBottom
                Predict = predict(EdgeT2ProstateNet,slice(x-7:x+7,y-7:y+7));
                heatmap(x,y) = Predict(2);
                Predict2 = predict(EdgeNewT2ProstateNet,slice(x-14:x+14,y-14:y+14));
                heatmap2(x,y) = Predict2(2);
            end
        end
        Patient(i).T2(ii).ProstateHeatmap = heatmap;
        Patient(i).T2(ii).EdgeProstateHeatmap = heatmap2;
        Patient(i).T2(ii).CombinedProstateHeatmap = (heatmap+heatmap2)/2;
    end
end
%% Heatmap Overlay

patient = 76;
sliceNum = 2;



%Seg = bwboundaries(imresize(Patient(patient).T2(sliceNum).PROI,1/2));
slice = imresize(adapthisteq(Patient(patient).T2(sliceNum).Slice),1/2);
 
figure, imshow(slice)
figure, imshowpair(slice,Patient(patient).T2(sliceNum).ProstateHeatmap);
figure, imshow(mat2gray(Patient(patient).T2(sliceNum).ProstateHeatmap))
% hold on
% for k = 1:length(Seg)
%     boundary = Seg{k};
%     plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
% end

%% Chan-Vese + Smoothing

for i = 76:76
    disp(i)
    numSlices = length(Patient(i).T2);
    for ii = 2:2
        
        maxPix = 0;
        for a = 16:241
            for b = 16:241
                sumPix = sum(sum(Patient(i).T2(ii).CombinedProstateHeatmap(a-10:a+10,b-10:b+10)));
                if (sumPix > maxPix)
                    x = a;
                    y = b;
                    maxPix = sumPix;
                end
            end
        end
        
        x = 128;
        y = 128;
        
        Mask = zeros(256,256);
        Mask(x,y) = 1;
        Mask(x-1,y) = 1;

        newROI = activecontour(Patient(i).T2(ii).CombinedProstateHeatmap,Mask,65,'Chan-Vese');
        windowSize = 10;
        kernel = ones(windowSize) / windowSize ^ 2;
        blurryImage = conv2(single(newROI), kernel, 'same');
        binaryImage = blurryImage > 0.5;
        
        Patient(i).T2(ii).CombinedPROI = binaryImage;
    end
end

%% Seg on Slice

patient = 52;
sliceNum = 1;

slice = imresize(adapthisteq(Patient(patient).T2(sliceNum).Slice),1/2);
newSeg = bwboundaries(Patient(patient).T2(sliceNum).CombinedPROI);
seg = bwboundaries(imresize(Patient(patient).T2(sliceNum).ROI,1/2));


figure,
imshow(slice);
hold on
for k = 1:length(newSeg)
    boundary = newSeg{k};
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end
% for k = 1:length(seg)
%     boundary = seg{k};
%     plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
% end

%% Raw Image

patient = 76;
sliceNum = 2;

Seg = bwboundaries(imresize(Patient(patient).T2(sliceNum).PROI,1/2));
figure,
imshow(imresize(Patient(patient).T2(sliceNum).Slice,1/2));
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

%% ROC AUC

score = zeros(700000,1);
actual = zeros(700000,1);

currentIndex = 1;

for i = 58:77
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        for ii = 1:length(Patient(i).PRegistration.ADC)
            disp([int2str(i), ' ', int2str(ii)])

            T2PROI = Patient(i).PRegistration.ADC(ii).PROI;
            box = regionprops(T2PROI,'BoundingBox');

            xLeft = round(box.BoundingBox(1)) - 10;
            yTop = round(box.BoundingBox(2)) - 10;
            xRight = round(box.BoundingBox(1)) + box.BoundingBox(3) + 10;
            yBottom = round(box.BoundingBox(2)) + box.BoundingBox(4) + 10;
            % Patient(i).T2(ii)
            heatmap = (Patient(i).PRegistration.ADC(ii).LargeLesionHeatmap+Patient(i).PRegistration.ADC(ii).SmallLesionHeatmap+Patient(i).PRegistration.DWI(ii).LargeLesionHeatmap+Patient(i).PRegistration.DWI(ii).SmallLesionHeatmap)/4;
            AllROI = zeros(256,256);
            for a = 1:256
                for b = 1:256
                    if (Patient(i).PRegistration(1).ADC(ii).ROI(a,b) ~= 0 || Patient(i).PRegistration(1).DWI(ii).ROI(a,b) ~= 0)
                        AllROI(a,b) = 1;
                    end
                end
            end

            for x = xLeft:xRight
                for y = yTop:yBottom
                    score(currentIndex) = heatmap(x,y);
                    actual(currentIndex) = AllROI(x,y);
                    currentIndex = currentIndex + 1;
                end
            end
        end
    end
end


[~,~,~,AUC] = perfcurve(actual(1:currentIndex),score(1:currentIndex),1);


%% Dice Score

for i = 73:77
    numSlices = length(Patient(i).T2);
    for ii = 1:numSlices
        centroid = regionprops(ones(256,256),Patient(i).T2(ii).CombinedProstateHeatmap,'weightedcentroid');
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

        newROI = activecontour(Patient(i).T2(ii).CombinedProstateHeatmap,Mask,60,'Chan-Vese');
        windowSize = 10;
        kernel = ones(windowSize) / windowSize ^ 2;
        blurryImage = conv2(single(newROI), kernel, 'same');
        binaryImage = blurryImage > 0.5;
        
        Patient(i).T2(ii).SmallPROI = binaryImage;
    end
end


diceScores = [];

for i = 73:77
    numSlices = length(Patient(i).T2);
    for ii = 1:numSlices
        diceScores = [diceScores,dice(Patient(i).T2(ii).SmallPROI,imresize(Patient(i).T2(ii).PROI,1/2))];
    end
end

mean(diceScores)
std(diceScores)