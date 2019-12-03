%% Train/Test Location

counterH = 0;
counterL = 0;
for i = 1:57
    numSlices = length(Patient(i).DWI);
        for ii = 1:numSlices
            
            proi = Patient(i).DWI(ii).PROI;
            
            box = regionprops(proi,'Centroid');
            box = box.Centroid;
            
            startX = box(1) - 64;
            endX = box(1) + 63;
            startY = box(2) - 64;
            endY = box(2) + 63;

            slice = Patient(i).DWI(ii).Slice;
            slice = slice(startY:endY,startX:endX);
            imwrite(slice*255, ['TrainingImagesDWI/DWIimage_', int2str(i) , '_', int2str(ii), '.gif'], 'GIF');
            
            roi = zeros(128,128);
            original = Patient(i).DWI(ii).ROI;
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
            imwrite(roi, ['TrainingMasksDWI/DWIimage_', int2str(i) , '_', int2str(ii), '.png'], 'PNG');
        end
end
%% Prepare datastores

imageDir = fullfile('TrainingImagesDWI');
labelDir = fullfile('TrainingMasksDWI');

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