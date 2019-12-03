%% Training Data

prostateT2_yTrain = [];
prostateT2_xTrain = [];

%% Need to collect more about edges (inside and out) and other nearby structures, also use adapthisteq
for i = 58:72
    numSlices = length(Patient(i).T2);
    
    for ii = 1:numSlices 
        
        slice = imresize(adapthisteq(Patient(i).T2(ii).Slice),1/2);
        proi = imresize(Patient(i).T2(ii).PROI,1/2);
        
        disp([int2str(i), ' ', int2str(ii)])
        
        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);
        
        xLeft = 21;
        yTop = 21;
        xRight = 235;
        yBottom = 235;
        
        for x = xLeft:xRight
            for y = yTop:yBottom
                if proi(x,y) == 0
                    prostatePix = 0;
                    if (usedOutsideEdge(x,y) == 0 && x > 64 && x < 192 && y > 50 && y < 192)
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                prostatePix = prostatePix + proi(a,b);
                            end
                        end
                    end
                  
                    
                    if prostatePix ~= 0
                        prostateT2_xTrain = cat(4, prostateT2_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTrain = [prostateT2_yTrain,0];
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end                        
                    elseif (usedOutside(x,y) == 0)
                        for a = max(x-75,1):min(x+75,256)
                            for b = max(y-75,1):min(y+75,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                        prostateT2_xTrain = cat(4, prostateT2_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTrain = [prostateT2_yTrain,0];
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * proi(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        prostateT2_xTrain = cat(4, prostateT2_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTrain = [prostateT2_yTrain,1];
                        for a = max(x-7,1):min(x+7,256)
                            for b = max(y-7,1):min(y+7,256)
                                usedInsideEdge(a,b) = 1;
                            end
                        end
                    elseif (usedInside(x,y) == 0)
                        for a = max(x-7,1):min(x+7,256)
                            for b = max(y-7,1):min(y+7,256)
                                usedInside(a,b) = 1;
                            end
                        end
                        prostateT2_xTrain = cat(4, prostateT2_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTrain = [prostateT2_yTrain,1];
                    end
                end
                
            end
        end
    end
end

prostateT2_yTrain = categorical(prostateT2_yTrain);

%% Test Data

prostateT2_yTest = [];
prostateT2_xTest = [];

for i = 73:77
    numSlices = length(Patient(i).T2);
    
    for ii = 1:numSlices
        
        slice = imresize(adapthisteq(Patient(i).T2(ii).Slice),1/2);
        proi = imresize(Patient(i).T2(ii).PROI,1/2);
        
        disp([int2str(i), ' ', int2str(ii)])
        
        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);
        
        xLeft = 21;
        yTop = 64;
        xRight = 235;
        yBottom = 192;
        
        for x = xLeft:xRight
            for y = yTop:yBottom
                if proi(x,y) == 0
                    
                    prostatePix = 0;
                    if (usedOutsideEdge(x,y) == 0 && x > 64 && x < 192 && y > 50 && y < 192)
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                prostatePix = prostatePix + proi(a,b);
                            end
                        end
                    end
                  
                    
                    if prostatePix ~= 0
                        prostateT2_xTest = cat(4, prostateT2_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTest = [prostateT2_yTest,0];
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end
                    elseif (usedOutside(x,y) == 0)
                        for a = max(x-75,1):min(x+75,256)
                            for b = max(y-75,1):min(y+75,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                        prostateT2_xTest = cat(4, prostateT2_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTest = [prostateT2_yTest,0];
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * proi(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        prostateT2_xTest = cat(4, prostateT2_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTest = [prostateT2_yTest,1];
                        for a = max(x-7,1):min(x+7,256)
                            for b = max(y-7,1):min(y+7,256)
                                usedInsideEdge(a,b) = 1;
                            end
                        end
                    elseif (usedInside(x,y) == 0)
                        for a = max(x-7,1):min(x+7,256)
                            for b = max(y-7,1):min(y+7,256)
                                usedInside(a,b) = 1;
                            end
                        end
                        prostateT2_xTest = cat(4, prostateT2_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateT2_yTest = [prostateT2_yTest,1];
                    end
                end
                
            end
        end
    end
end

prostateT2_yTest = categorical(prostateT2_yTest);