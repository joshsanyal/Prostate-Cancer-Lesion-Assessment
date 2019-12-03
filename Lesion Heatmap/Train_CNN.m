%% Small
 
imageSize = [11 11 2];

layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(3,6,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    convolution2dLayer(3,12,'Padding','same')
    batchNormalizationLayer
    reluLayer
        
    fullyConnectedLayer(100)
    reluLayer
        
    fullyConnectedLayer(3)
    
    softmaxLayer
    classificationLayer];


opts = trainingOptions('adam', ...
    'MaxEpochs',10, ...
    'InitialLearnRate', 0.001, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'ValidationFrequency',20, ...
    'Verbose',false, ...
    'ValidationData',{lesionAll_xTest(:,:,1:2,:),lesionAll_yTest}, ...
    'ValidationPatience',Inf);

ADC_High_SmallLesionNet = trainNetwork(lesionAll_xTrain(:,:,1:2,:),lesionAll_yTrain,layers,opts);

%% Combined

imageSize = [21 21 2];

layers = [
    image3dInputLayer(imageSize)
    
    convolution3dLayer(5,6,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling3dLayer(2,'Stride',2)
    
    convolution3dLayer(3,12,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(100)
    reluLayer
    
    fullyConnectedLayer(3)
    
    softmaxLayer
    classificationLayer];

opts = trainingOptions('adam', ...
    'MaxEpochs',10, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'ValidationFrequency',20, ...
    'Verbose',false, ...
    'ValidationData',{lesionAll_xTest(:,:,1:2,:),lesionAll_yTest}, ...
    'ValidationPatience',Inf);

DWI_Low_LargeLesionNet = trainNetwork(lesionAll_xTrain(:,:,1:2,:),lesionAll_yTrain,layers,opts);