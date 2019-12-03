%% Global

imageSize = [29 29 1];

layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(3,64,'Padding','same') % might need to change to 3d
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
    'ValidationData',{prostateT2_xTest,prostateT2_yTest},...
    'ValidationPatience',Inf);

EdgeNewT2ProstateNet = trainNetwork(prostateT2_xTrain,prostateT2_yTrain,layers,opts);

%% Local

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
    'MaxEpochs',10, ...
    'InitialLearnRate', 0.001, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'ValidationFrequency',20,...
    'Verbose',false, ...
    'ValidationData',{prostateT2_xTest,prostateT2_yTest},...
    'ValidationPatience',Inf);

EdgeT2ProstateNet = trainNetwork(prostateT2_xTrain,prostateT2_yTrain,layers,opts);