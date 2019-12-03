%% Manual Seg
for i = 15:57
    for ii = 1:length(Patient(i).DWI)
        imshow(adapthisteq(Patient(i).DWI(ii).Slice))
        [x, y] = getline(gcf,'closed');
        Patient(i).DWI(ii).PROI = poly2mask(x,y,256,256);
    end
end

for i = 1:57
    for ii = 1:length(Patient(i).ADC)
        imshow(adapthisteq(Patient(i).ADC(ii).Slice))
        [x, y] = getline(gcf,'closed');
        Patient(i).ADC(ii).PROI = poly2mask(x,y,256,256);
    end
end

%% Registration

[Patient(i).Manual.ADC(ii).Slice, Patient(i).Manual.ADC(ii).ROI, Patient(i).Manual.ADC(ii).PROI] = ShapeBasedRegistration(double(Patient(i).T2(ii).PROI),double(Patient(i).ADC(ii).PROI),double(Patient(i).ADC(ii).Slice),double(Patient(i).ADC(ii).ROI));
[Patient(i).Manual.DWI(ii).Slice, Patient(i).Manual.DWI(ii).ROI, Patient(i).Manual.DWI(ii).PROI] = ShapeBasedRegistration(double(Patient(i).T2(ii).PROI),double(Patient(i).DWI(ii).PROI),double(Patient(i).DWI(ii).Slice),double(Patient(i).DWI(ii).ROI));

%% Heatmap Gen


ADCslice = adapthisteq(Patient(i).Manual.ADC(ii).Slice);
DWIslice = Patient(i).Manual.DWI(ii).Slice;

ROIheatmap = zeros(256,256);
ROIheatmap2 = zeros(256,256);
ROIheatmap3 = zeros(256,256);
ROIheatmap4 = zeros(256,256);

T2PROI = Patient(i).Manual.ADC(ii).PROI;
box = regionprops(T2PROI,'BoundingBox');

xLeft = round(box.BoundingBox(1)) - 10;
yTop = round(box.BoundingBox(2)) - 10;
xRight = round(box.BoundingBox(1)) + box.BoundingBox(3) + 10;
yBottom = round(box.BoundingBox(2)) + box.BoundingBox(4) + 10;


for x = yTop:yBottom
   disp([int2str(i), ' ', int2str(ii), ' ', int2str(x)])
    for y = xLeft:xRight
        Predict = predict(DWI_High_SmallLesionNet,DWIslice(x-5:x+5,y-5:y+5));
        ROIheatmap(x,y) = Predict(2);

        Predict2 = predict(DWI_High_LargeLesionNet,DWIslice(x-10:x+10,y-10:y+10));
        ROIheatmap2(x,y) = Predict2(2);

        Predict3 = predict(ADC_High_SmallLesionNet,ADCslice(x-5:x+5,y-5:y+5));
        ROIheatmap3(x,y) = Predict3(2);

        Predict4 = predict(ADC_High_LargeLesionNet,ADCslice(x-10:x+10,y-10:y+10));
        ROIheatmap4(x,y) = Predict4(2);
    end
end

Patient(i).Manual.DWI(ii).SmallLesionHeatmap = ROIheatmap;
Patient(i).Manual.DWI(ii).LargeLesionHeatmap = ROIheatmap2;
Patient(i).Manual.DWI(ii).CombinedLesionHeatmap = (ROIheatmap2+ROIheatmap)/2;
Patient(i).Manual.ADC(ii).SmallLesionHeatmap = ROIheatmap3;
Patient(i).Manual.ADC(ii).LargeLesionHeatmap = ROIheatmap4;
Patient(i).Manual.ADC(ii).CombinedLesionHeatmap = (ROIheatmap3+ROIheatmap4)/2; 

%% Heatmap

patient = 52;
sliceNum = 1;

AllROI = zeros(256,256);
for a = 1:256
    for b = 1:256
        if (Patient(patient).Manual(1).ADC(sliceNum).ROI(a,b) ~= 0 || Patient(patient).Manual(1).DWI(sliceNum).ROI(a,b) ~= 0)
            AllROI(a,b) = 1;
        end
    end
end
Seg = bwboundaries(AllROI);
ROIheatmap = (Patient(patient).Manual(1).ADC(sliceNum).CombinedLesionHeatmap+Patient(patient).Manual(1).DWI(sliceNum).CombinedLesionHeatmap)/2;

figure,
imshowpair((adapthisteq(Patient(patient).Manual(1).ADC(sliceNum).Slice)),ROIheatmap);
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end
figure,
imshow((adapthisteq(Patient(patient).Manual(1).DWI(sliceNum).Slice)))

%% Seg

patient = 46;
sliceNum = 1;

ROIheatmap = (Patient(patient).Manual(1).ADC(sliceNum).CombinedLesionHeatmap+Patient(patient).Manual(1).DWI(sliceNum).CombinedLesionHeatmap)/2;

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

x = 147;
y = 119;
scaleFactor = 4;

ROI = zeros(256*scaleFactor,256*scaleFactor);
for i = x*scaleFactor - 5 : x*scaleFactor + 5
    for j = y*scaleFactor - 5 : y*scaleFactor + 5
        ROI(i,j) = 1;
    end
end

ROIheatmap = imresize(ROIheatmap,scaleFactor);

pixDiff = 0;
meanIns.MeanIntensity = 1;
while pixDiff < 0.04
    newROI = activecontour(ROIheatmap,ROI,2,'Chan-Vese');
    meanIns = regionprops(ROI,ROIheatmap,'MeanIntensity');
    meanOut = regionprops(newROI,ROIheatmap,'MeanIntensity');
    pixDiff = meanIns.MeanIntensity - (meanOut.MeanIntensity*sum(newROI(:))-meanIns.MeanIntensity*sum(ROI(:)))/(sum(newROI(:)) - sum(ROI(:)));
    ROI = newROI;
end
for i = 1:30
    newROI = activecontour(ROIheatmap,ROI,2,'Chan-Vese');
    meanIns = regionprops(ROI,ROIheatmap,'MeanIntensity');
    meanOut = regionprops(newROI,ROIheatmap,'MeanIntensity');
    pixDiff = meanIns.MeanIntensity - (meanOut.MeanIntensity*sum(newROI(:))-meanIns.MeanIntensity*sum(ROI(:)))/(sum(newROI(:)) - sum(ROI(:)));
    ROI = newROI; 
end

newROI = imresize(newROI,1/scaleFactor);
windowSize = 5;
kernel = ones(windowSize) / windowSize ^ 2;
blurryImage = conv2(single(newROI), kernel, 'same');
binaryImage = blurryImage > 0.5;

Patient(patient).Manual.All(sliceNum).CombinedPROI = binaryImage;

%% Visualize

patient = 46;
sliceNum = 1;

newSeg = bwboundaries(Patient(patient).Manual.All(sliceNum).CombinedPROI);

AllROI = zeros(256,256);
for a = 1:256
    for b = 1:256
        if (Patient(patient).Manual.ADC(sliceNum).ROI(a,b) ~= 0 || Patient(patient).Manual.DWI(sliceNum).ROI(a,b) ~= 0)
            AllROI(a,b) = 1;
        end
    end
end
Seg = bwboundaries(AllROI);


figure,
imshow(((Patient(patient).Manual.DWI(sliceNum).Slice)))
hold on
for k = 1:length(Seg)
    boundary = Seg{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end
hold on
for k = 1:length(newSeg)
    boundary = newSeg{k};
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end

[x,y] = getpts

%% 
i = 46;
ii = 1;


AllROI = zeros(256,256);
for a = 1:256
    for b = 1:256
        if (Patient(i).Manual.ADC(ii).ROI(a,b) ~= 0 || Patient(i).Manual.DWI(ii).ROI(a,b) ~= 0)
            AllROI(a,b) = 1;
        end
    end
end

dice(Patient(i).Manual.All(ii).CombinedPROI,logical(AllROI))