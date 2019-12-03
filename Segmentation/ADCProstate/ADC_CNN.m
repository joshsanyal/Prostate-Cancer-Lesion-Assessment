%% Medium

imageSize = [29 29 1];

layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(3,64,'Padding','same') % run all 10 epochs and mess with learning rate
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer
        
    convolution2dLayer(5,256,'Padding','same')
    batchNormalizationLayer
    reluLayer
        
    fullyConnectedLayer(2048)
        
    fullyConnectedLayer(512)
        
    fullyConnectedLayer(2)
    
    softmaxLayer
    classificationLayer];


opts = trainingOptions('sgdm', ...
    'MaxEpochs',10, ...    
    'InitialLearnRate', 0.001, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'ValidationFrequency',20,...
    'Verbose',false, ...
    'ValidationData',{prostateADC_xTest,prostateADC_yTest},...
    'ValidationPatience',Inf);

EdgeNewADCProstateNet = trainNetwork(prostateADC_xTrain,prostateADC_yTrain,layers,opts);

%% Small

imageSize = [15 15 1];

layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(3,64,'Padding','same') % might need to change to 3d
    batchNormalizationLayer
    reluLayer
    
    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
     convolution2dLayer(3,256,'Padding','same')
    batchNormalizationLayer
    reluLayer
       
    reluLayer
    
    fullyConnectedLayer(2048)
    
    fullyConnectedLayer(512)
    
    fullyConnectedLayer(2)
    
    softmaxLayer
    classificationLayer];


opts = trainingOptions('sgdm', ...
    'MaxEpochs',8, ...    
    'InitialLearnRate', 0.001, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'ValidationFrequency',20,...
    'Verbose',false, ...
    'ValidationData',{prostateADC_xTest,prostateADC_yTest},...
    'ValidationPatience',Inf);


% augmenter = imageDataAugmenter( ...
%     'RandXReflection',true, ...
%     'RandRotation',[0 360], ...
%     'RandYReflection',true);
% 
% augimds = augmentedImageDatastore(imageSize,prostateADC_xTrain,prostateADC_yTrain,'DataAugmentation',augmenter);

EdgeADCProstateNet = trainNetwork(prostateADC_xTrain,prostateADC_yTrain,layers,opts);