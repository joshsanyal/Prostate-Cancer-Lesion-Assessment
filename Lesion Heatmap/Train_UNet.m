%% Train/Test Location

counterH = 0;
counterL = 0;
for i = 1:57
    numSlices = length(Patient(i).PRegistration.ADC);
    if (Patient(i).truth(1) == 'H' && i ~= 6 && i ~= 12 && i ~= 13 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44)
        for ii = 1:numSlices
            
            proi = zeros(256,256);
            if (i == 17)
                proi = (Patient(i).PRegistration.CombinedPROI);
            elseif (i == 14 || i == 28)
                proi = imresize(Patient(i).T2(1).PROI,1/2);
            else
                proi = imresize(Patient(i).T2(ii).PROI,1/2);
            end
            
            box = regionprops(proi,'Centroid');
            box = box.Centroid;
            
            startX = box(1) - 64;
            endX = box(1) + 63;
            startY = box(2) - 64;
            endY = box(2) + 63;

            slice = Patient(i).PRegistration.ADC(ii).Slice;
            slice = slice(startY:endY,startX:endX);
            imwrite(slice*255, ['TrainingImagesADC/ADCimage_', int2str(i) , '_', int2str(ii), '.gif'], 'GIF');
            
            roi = zeros(128,128);
            original = Patient(i).PRegistration.ADC(ii).ROI;
            original = original(startY:endY,startX:endX);
            class = 255;
            for a=1:128
                for b=1:128
                    if (original(a,b) > 0)
                        roi(a,b) = class;
                    end
                end
            end
           % imshow(roi)
            imwrite(roi, ['TrainingMasksADC/ADCimage_', int2str(i) , '_', int2str(ii), '.png'], 'PNG');
        end
    end
end
%% Prepare datastores

imageDir = fullfile('TrainingImagesADC');
labelDir = fullfile('TrainingMasksADC');

imds = imageDatastore(imageDir);

classNames = ["high","outside"];
labelIDs   = [255 0];

pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);
ds = pixelLabelImageDatastore(imds,pxds);

%% Training 

imageSize = [16 16];
numClasses = 3;
lgraph = unetLayers(imageSize, numClasses, 'encoderDepth', 2);

opts = trainingOptions('sgdm', ...
    'MiniBatchSize',15,...
    'MaxEpochs',1, ...
    'InitialLearnRate', 0.001, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false);

%net = trainNetwork(lesionAll_xTrain(:,:,1,:), lesionAll_xTrain(:,:,4,:), lgraph,opts);

%%

imwrite(train_labels,'train_labels.png');