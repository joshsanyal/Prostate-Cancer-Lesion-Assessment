 %% Create ROIheatmap

for i = 77:77
    
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        numSlices = length(Patient(i).PRegistration.ADC);
        
        for ii = 1:1

            ADCslice = adapthisteq(Patient(i).PRegistration.ADC(ii).Slice);
            DWIslice = adapthisteq(Patient(i).PRegistration.DWI(ii).Slice);
            
            ROIheatmap_high = zeros(256,256);
            ROIheatmap2_high = zeros(256,256);
            ROIheatmap3_high = zeros(256,256);
            ROIheatmap4_high = zeros(256,256);
            
            ROIheatmap_low = zeros(256,256);
            ROIheatmap2_low = zeros(256,256);
            ROIheatmap3_low = zeros(256,256);
            ROIheatmap4_low = zeros(256,256);

            T2PROI = Patient(i).PRegistration.ADC(ii).PROI;
            box = regionprops(T2PROI,'BoundingBox');

            xLeft = round(box.BoundingBox(1)) - 10;
            yTop = round(box.BoundingBox(2)) - 10;
            xRight = round(box.BoundingBox(1)) + box.BoundingBox(3) + 10;
            yBottom = round(box.BoundingBox(2)) + box.BoundingBox(4) + 10;

            for x = yTop:yBottom
               disp([int2str(i), ' ', int2str(ii), ' ', int2str(x)])
                for y = xLeft:xRight

                    Predict3 = predict(ADC_High_SmallLesionNet,cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5)));
                    ROIheatmap3_low(x,y) = Predict3(2);
                    ROIheatmap3_high(x,y) = Predict3(3);

%                     Predict4 = predict(ADC_Low_LargeLesionNet,ADCslice(x-10:x+10,y-10:y+10));
%                     ROIheatmap4_low(x,y) = Predict4(2);
%                     ROIheatmap4_high(x,y) = Predict4(3);
                end
            end
            
%             Patient(i).PRegistration.DWI(ii).SmallLesionHeatmap_low = ROIheatmap_low;
%             Patient(i).PRegistration.DWI(ii).LargeLesionHeatmap_low = ROIheatmap2_low;
%             Patient(i).PRegistration.DWI(ii).CombinedLesionHeatmap_low = (ROIheatmap2_low+ROIheatmap_low)/2;
%             Patient(i).PRegistration.ADC(ii).SmallLesionHeatmap_low = ROIheatmap3_low;
%             Patient(i).PRegistration.ADC(ii).LargeLesionHeatmap_low = ROIheatmap4_low;
%             Patient(i).PRegistration.ADC(ii).CombinedLesionHeatmap_low = (ROIheatmap3_low+ROIheatmap4_low)/2; 
%             
%             Patient(i).PRegistration.DWI(ii).SmallLesionHeatmap_high = ROIheatmap_high;
%             Patient(i).PRegistration.DWI(ii).LargeLesionHeatmap_high = ROIheatmap2_high;
%             Patient(i).PRegistration.DWI(ii).CombinedLesionHeatmap_high = (ROIheatmap2_high+ROIheatmap_high)/2;
%             Patient(i).PRegistration.ADC(ii).SmallLesionHeatmap_high = ROIheatmap3_high;
%             Patient(i).PRegistration.ADC(ii).LargeLesionHeatmap_high = ROIheatmap4_high;
%             Patient(i).PRegistration.ADC(ii).CombinedLesionHeatmap_high = (ROIheatmap3_high+ROIheatmap4_high)/2; 
        end
    end
end
%% ROIheatmap Overlay

patient = 77;
sliceNum = 1;

AllROI = zeros(256,256);
for a = 1:256
    for b = 1:256
        if (Patient(patient).PRegistration(1).ADC(sliceNum).ROI(a,b) ~= 0 || Patient(patient).PRegistration(1).DWI(sliceNum).ROI(a,b) ~= 0)
            AllROI(a,b) = 1;
        end
    end
end
Seg = bwboundaries(AllROI);
% ROIheatmap = (Patient(patient).PRegistration(1).ADC(sliceNum).CombinedLesionHeatmap_low+Patient(patient).PRegistration(1).DWI(sliceNum).CombinedLesionHeatmap_low)/2;
% ROIheatmap1 = (Patient(patient).PRegistration(1).ADC(sliceNum).CombinedLesionHeatmap_high+Patient(patient).PRegistration(1).DWI(sliceNum).CombinedLesionHeatmap_high)/2;


overlay_im = cat(3, ROIheatmap3_high/2, ROIheatmap3_low/1.3, imresize(Patient(patient).T2(sliceNum).Slice,1/2));

figure,
imshow(overlay_im);
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

figure,
imshow((adapthisteq(Patient(patient).PRegistration(1).DWI(sliceNum).Slice)))
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

%% 

for patient = 56:56
    disp(patient)
    if (patient ~= 6 && patient ~= 12 && patient ~= 13 && patient ~= 22 && patient ~= 24 && patient ~= 27 && patient ~= 32 && patient ~= 38 && patient ~= 44 && patient ~= 54)
        for sliceNum = 2:2

            ROIheatmap = (Patient(patient).PRegistration(1).ADC(sliceNum).CombinedLesionHeatmap_high+Patient(patient).PRegistration(1).DWI(sliceNum).CombinedLesionHeatmap_high)/2;

            counter = 0;
            sumPixels = 0;
            maxPix = 0;
            for a = 15:240
                for b = 15:240
                    sumPix = sum(sum(ROIheatmap(a-2:a+1,b-2:b+1)));
                    if (sumPix > maxPix)
                        x = a;
                        y = b;
                        maxPix = sumPix;
                    end
                    if (ROIheatmap(a,b) ~= 0)
                        sumPixels = sumPixels + ROIheatmap(a,b);
                        counter = counter + 1;
                    end
                end
            end
            
            scaleFactor = 4;
            
            ROI = zeros(256*scaleFactor,256*scaleFactor);
            for i = x*scaleFactor - 5 : x*scaleFactor + 5
                for j = y*scaleFactor - 5 : y*scaleFactor + 5
                    ROI(i,j) = 1;
                end
            end

            ROIheatmap = imresize(ROIheatmap,scaleFactor);
            
            

            pixDiff = 0;
            entropyIns = 1;
            while pixDiff < 0.08
                newROI = activecontour(ROIheatmap,ROI,3,'Chan-Vese');
                meanIns = regionprops(ROI,ROIheatmap,'MeanIntensity');
                meanOut = regionprops(newROI,ROIheatmap,'MeanIntensity');
                pixDiff = entropyIns - (meanOut(length(meanOut)).MeanIntensity*sum(newROI(:))-entropyIns*sum(ROI(:)))/(sum(newROI(:)) - sum(ROI(:)));
                ROI = newROI;
            end
                newROI = activecontour(ROIheatmap,ROI,50,'Chan-Vese');
                meanIns = regionprops(ROI,ROIheatmap,'MeanIntensity');
                meanOut = regionprops(newROI,ROIheatmap,'MeanIntensity');
                pixDiff = entropyIns - (meanOut(length(meanOut)).MeanIntensity*sum(newROI(:))-entropyIns*sum(ROI(:)))/(sum(newROI(:)) - sum(ROI(:)));
                ROI = newROI;
                
            newROI = imresize(newROI,1/scaleFactor);
            windowSize = 5;
            kernel = ones(windowSize) / windowSize ^ 2;
            blurryImage = conv2(single(newROI), kernel, 'same');
            binaryImage = blurryImage > 0.5;

            Patient(patient).PRegistration.All(sliceNum).CombinedPROI_high = binaryImage;
            
            
        end
        
    end
end
%% 

patient = 56;
sliceNum = 2;

newSeg = bwboundaries(Patient(patient).PRegistration.All(sliceNum).CombinedPROI_high);

    AllROI = zeros(256,256);
    for a = 1:256
        for b = 1:256
            if (Patient(patient).PRegistration.ADC(sliceNum).ROI(a,b) ~= 0 || Patient(patient).PRegistration.DWI(sliceNum).ROI(a,b) ~= 0)
                AllROI(a,b) = 1;
            end
        end
    end
    Seg = bwboundaries(AllROI);


    figure,
    imshow(adapthisteq((Patient(patient).DWI(sliceNum).Slice)))
%     hold on
%     for k = 1:length(Seg)
%         boundary = Seg{k};
%         plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
%     end
    hold on
    for k = 1:length(newSeg)
        boundary = newSeg{k};
        plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 3)
    end
    
   % [x,y] = getpts
%% 

for i = 48:48
    disp(i)
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        for ii = 1:length(Patient(i).PRegistration(1).ADC)
%           T2PROI = imresize(Patient(i).T2(ii).PROI,1/2);
            AllROI = zeros(256,256);
            for a = 1:256
                for b = 1:256
                    if (Patient(i).PRegistration.ADC(ii).ROI(a,b) ~= 0 || Patient(i).PRegistration.DWI(ii).ROI(a,b) ~= 0)
                        AllROI(a,b) = 1;
                    end
                end
            end

            highDiceScores{i,ii} = dice(Patient(i).PRegistration.All(ii).CombinedPROI_high,logical(AllROI));
        end
        
    end
end

%%
for i = 1:57
    disp(i)
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
         highDiceScores{i,8} = Patient(i).truth;
    end
end

%% dice score
dicesc = []; 
counter2 = 0;

for i = 1:57
    disp(i)
    maxProb = 0; % best seg relative to img
    maxIndex = 1; % slice number
    maxState = 0; % set to 1 if low model
    if (Patient(i).truth(1) == 'H' && i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        for ii = 1:length(Patient(i).PRegistration(1).ADC)
            heatmap = (Patient(i).PRegistration(1).ADC(ii).Low_CombinedLesionHeatmap+Patient(i).PRegistration(1).DWI(ii).Low_CombinedLesionHeatmap)/2;
            
            outsideROI = Patient(i).PRegistration.All(ii).CombinedPROI == 0;
            for a = 1:256
                for b = 1:256
                    if (heatmap(a,b) == 0)
                        outsideROI(a,b) = 0;
                    end
                end
            end
            
            meanIns = regionprops(Patient(i).PRegistration.All(ii).Low_CombinedPROI,heatmap,'MeanIntensity');
            meanOut = regionprops(outsideROI, heatmap,'MeanIntensity');
            
            entropyIns = Ent(heatmap,Patient(i).PRegistration.All(ii).CombinedPROI);
            entropyOut = Ent(heatmap,outsideROI);

            if ((entropyIns*(entropyOut)*(diceScores{i,ii}-0.5))/(entropyOut*(entropyIns)) > maxProb) 
              maxProb = (entropyIns*(entropyOut)*(diceScores{i,ii}-0.5))/(entropyOut*(entropyIns));
              maxState = 0;
              maxIndex = ii;
            end
            
            heatmap = (Patient(i).PRegistration(1).ADC(ii).Low_CombinedLesionHeatmap+Patient(i).PRegistration(1).DWI(ii).Low_CombinedLesionHeatmap)/2;
            
            outsideROI = Patient(i).PRegistration.All(ii).CombinedPROI == 0;
            for a = 1:256
                for b = 1:256
                    if (heatmap(a,b) == 0)
                        outsideROI(a,b) = 0;
                    end
                end
            end
            meanIns = regionprops(Patient(i).PRegistration.All(ii).Low_CombinedPROI,heatmap,'MeanIntensity');
            meanOut = regionprops(outsideROI, heatmap,'MeanIntensity');
            
            entropyIns = Ent(heatmap,Patient(i).PRegistration.All(ii).CombinedPROI);
            entropyOut = Ent(heatmap,outsideROI);
            
            if ((entropyIns*(entropyOut)*(diceScores_low{i,ii}-0.5))/(entropyOut*(entropyIns)) > maxProb) 
              maxProb = (entropyIns*(entropyOut)*(diceScores_low{i,ii}-0.5))/(entropyOut*(entropyIns));
              maxState = 1;
              maxIndex = ii;
            end
        end

        if (maxState == 0) 
            if (diceScores{i,maxIndex} ~= 0)
                dicesc = [dicesc; diceScores{i,maxIndex}];
                Patient(i).Test.ADC = Patient(i).PRegistration(1).ADC(maxIndex).Slice;
                Patient(i).Test.DWI = Patient(i).PRegistration(1).DWI(maxIndex).Slice;
                Patient(i).Test.T2 = Patient(i).T2(maxIndex).Slice;
                Patient(i).Test.ROI = Patient(i).PRegistration.All(ii).CombinedPROI;
            else 
                counter2 = counter2 + 1;
               dicesc = [dicesc; diceScores{i,maxIndex}];
            end
        else 
            if (diceScores_low{i,maxIndex} ~= 0)
                dicesc = [dicesc; diceScores_low{i,maxIndex}];
                Patient(i).Test.ADC = Patient(i).PRegistration(1).ADC(maxIndex).Slice;
                Patient(i).Test.DWI = Patient(i).PRegistration(1).DWI(maxIndex).Slice;
                Patient(i).Test.T2 = imresize(Patient(i).T2(maxIndex).Slice,1/2);
                Patient(i).Test.ROI = Patient(i).PRegistration.All(ii).Low_CombinedPROI;
            else 
                counter2 = counter2 + 1;
               dicesc = [dicesc; diceScores_low{i,maxIndex}];
            end
        end
    end
end

mean(dicesc)
std(dicesc)

%% accuracy of model
correct = 0;
total = 0;
dicescL = [];
dicescH = [];
for i = 1:57
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        disp(i)
        total = total + 1;
        cl = 'G';
        index = 0;
        maxProb = -100;
        for ii = 1:length(Patient(i).PRegistration(1).ADC)
            try 
                lowHeatmap = (Patient(patient).PRegistration(1).ADC(sliceNum).CombinedLesionHeatmap_low+Patient(patient).PRegistration(1).DWI(sliceNum).CombinedLesionHeatmap_low)/2;
                highHeatmap = (Patient(patient).PRegistration(1).ADC(sliceNum).CombinedLesionHeatmap_high+Patient(patient).PRegistration(1).DWI(sliceNum).CombinedLesionHeatmap_high)/2;

                lowOutsideROI = Patient(i).PRegistration.All(ii).CombinedPROI == 0;
                lowROI = Patient(i).PRegistration.All(ii).CombinedPROI_low;
                for a = 1:256
                    for b = 1:256
                        if (sum(sum(lowROI(max(1,a-2):min(256,a+2),max(1,b-2):min(256,b+2)))) == 0)
                            lowOutsideROI(a,b) = 0;
                        end
                    end
                end

                highOutsideROI = Patient(i).PRegistration.All(ii).CombinedPROI == 0;
                highROI = Patient(i).PRegistration.All(ii).CombinedPROI_high;
                for a = 1:256
                    for b = 1:256
                        if (sum(sum(highROI(max(1,a-2):min(256,a+2),max(1,b-2):min(256,b+2)))) == 0)
                            highOutsideROI(a,b) = 0;
                        end
                    end
                end

                meanIns = regionprops(lowROI,lowHeatmap,'MeanIntensity');
                meanOut = regionprops(lowOutsideROI, lowHeatmap,'MeanIntensity');
                
                entropyIns = Ent(lowHeatmap,lowROI);
                entropyOut = Ent(lowHeatmap,lowOutsideROI);

                if (entropyIns*(lowDiceScores{i,ii}+0.2)/entropyOut > maxProb) 
                  maxProb = entropyIns*(lowDiceScores{i,ii}+0.2)/entropyOut;
                  cl = 'L';
                  index = ii;
                end

                meanIns = regionprops(Patient(i).PRegistration.All(ii).CombinedPROI_high,highHeatmap,'MeanIntensity');
                meanOut = regionprops(highOutsideROI, highHeatmap,'MeanIntensity');

                entropyIns = Ent(highHeatmap,highROI);
                entropyOut = Ent(highHeatmap,highOutsideROI);
                
                if (entropyIns*(highDiceScores{i,ii}+0.2)/entropyOut > maxProb) 
                  maxProb = entropyIns*(highDiceScores{i,ii}+0.2)/entropyOut;
                  cl = 'H';
                  index = ii;
                end
            end
        end
        
        if (Patient(i).truth(1) == cl(1))
            correct = correct + 1;
        end
        
        if (cl(1) == 'L')
            dicescL = [dicescL; lowDiceScores{i,index}];
        else 
            dicescH = [dicescH; highDiceScores{i,index}];
        end
    end 
end

correct/total
mean(dicescH(dicescH ~= 0))
std(dicescH(dicescH ~= 0))
mean(dicescL(dicescL ~= 0))
std(dicescL(dicescL ~= 0))

%% 
for i = 58:77
    Patient(i).Test.ADC = Patient(i).PRegistration(1).ADC(maxIndex).Slice;
    Patient(i).Test.DWI = Patient(i).PRegistration(1).DWI(maxIndex).Slice;
    Patient(i).Test.T2 = imresize(Patient(i).T2(maxIndex).Slice,1/2);
    Patient(i).Test.ROI = Patient(i).PRegistration.All(ii).Low_CombinedPROI;
end

%% ROC AUC

highScore = zeros(2000000,1);
lowScore = zeros(2000000,1);
noScore = zeros(2000000,1);
actualHigh = zeros(2000000,1);
actualLow = zeros(2000000,1);
actualNo = zeros(2000000,1);

currentIndex = 1;

for i = 1:57
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        curMax = 0;
        for ii = 1:length(Patient(i).PRegistration.ADC)
            
            disp([int2str(i), ' ', int2str(ii)])

            T2PROI = Patient(i).PRegistration.ADC(ii).PROI;
            box = regionprops(T2PROI,'BoundingBox');
            xLeft = round(box.BoundingBox(1)) - 10;
            yTop = round(box.BoundingBox(2)) - 10;
            xRight = round(box.BoundingBox(1)) + box.BoundingBox(3) + 10;
            yBottom = round(box.BoundingBox(2)) + box.BoundingBox(4) + 10;

            lowHeatmap = (Patient(i).PRegistration(1).ADC(ii).CombinedLesionHeatmap_low+Patient(i).PRegistration(1).DWI(ii).CombinedLesionHeatmap_low)/2;
            highHeatmap = (Patient(i).PRegistration(1).ADC(ii).CombinedLesionHeatmap_high+Patient(i).PRegistration(1).DWI(ii).CombinedLesionHeatmap_high)/2;

            lowROI = zeros(256,256);
            highROI = zeros(256,256);

            t2Slice = imresize(Patient(patient).T2(sliceNum).ROI,1/2);

            if (Patient(i).truth(1) == 'H')
                for a = 1:256
                    for b = 1:256
                        if (Patient(patient).PRegistration.ADC(sliceNum).ROI(a,b) ~= 0 || Patient(patient).PRegistration.DWI(sliceNum).ROI(a,b) ~= 0)
                            highROI(a,b) = 1;
                        end
                    end
                end
            else
                for a = 1:256
                    for b = 1:256
                        if (Patient(patient).PRegistration.ADC(sliceNum).ROI(a,b) ~= 0 || Patient(patient).PRegistration.DWI(sliceNum).ROI(a,b) ~= 0)
                            lowROI(a,b) = 1;
                        end
                    end
                end
            end

            for x = yTop:yBottom
                for y = xLeft:xRight
                    highScore(currentIndex) = highHeatmap(x,y);
                    lowScore(currentIndex) = lowHeatmap(x,y);
                    noScore(currentIndex) = 1-(highHeatmap(x,y)+lowHeatmap(x,y));
                    actualHigh(currentIndex) = highROI(x,y);
                    actualLow(currentIndex) = lowROI(x,y);
                    actualNo(currentIndex) = (highROI(x,y) == 0 && lowROI(x,y) == 0);
                    currentIndex = currentIndex + 1;
                end
            end
        end
    end
end


[~,~,~,AUC] = perfcurve(actualHigh,highScore,1);
[~,~,~,AUC2] = perfcurve(actualLow,lowScore,1);
[~,~,~,AUC3] = perfcurve(actualNo,noScore,1);

[r1,p1] = corr(actualHigh, highScore);
[r2,p2] = corr(actualLow,lowScore);
[r3,p3] = corr(actualNo,noScore);

%% 
counter = 1;
distance = zeros(1000,1);
for i = 1:57
    disp(i)
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 22 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44 && i ~= 54)
        lowDist = 1000;
        curMax = 0;
        ii = 1;
        for j = 1:length(Patient(i).PRegistration.ADC)
            if (highDiceScores{i,j} > curMax) 
                curMax = highDiceScores{i,j};
                ii = j;
            end
        end
            
        t2Slice = imresize(Patient(patient).T2(sliceNum).ROI,1/2);

        lesionROI = zeros(256,256);
        for a = 1:256
            for b = 1:256
                if (Patient(i).PRegistration.ADC(ii).ROI(a,b) ~= 0 || Patient(i).PRegistration.DWI(ii).ROI(a,b) ~= 0 || t2Slice(a,b) ~= 0)
                    lesionROI(a,b) = 1;
                end
            end
        end
        centroid = regionprops(lesionROI,'Centroid');
        centroid2 = regionprops(Patient(i).PRegistration.All(ii).CombinedPROI_high,'Centroid'); 
        centroid3 = regionprops(Patient(i).PRegistration.All(ii).CombinedPROI_low,'Centroid');

        x1 = centroid.Centroid(1);
        y1 = centroid.Centroid(2);
        try
            x2 = centroid2.Centroid(1);
        catch
            x2 = 0;
        end
        try
            y2 = centroid2.Centroid(2);
        catch
            y2 = 0;
        end
        try
            x3 = centroid3.Centroid(1);
        catch
            x3 = 0;
        end
        try
            y3 = centroid3.Centroid(2);
        catch
            y3 = 0;
        end
        lowDist = min(lowDist, min(sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)), sqrt((x1-x3)*(x1-x3)+(y1-y3)*(y1-y3))));
        distance(counter) = lowDist;
        counter = counter + 1;
    end
end
