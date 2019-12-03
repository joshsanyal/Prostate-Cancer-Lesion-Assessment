%% Training Data

prostateDWI_yTrain = [];
prostateDWI_xTrain = [];

%% Need to collect more about edges (inside and out), less about out of prostate
for i = 58:60
    numSlices = length(Patient(i).DWI);
    
    for ii = 1:numSlices 
        
        slice = adapthisteq(Patient(i).DWI(ii).Slice);
        
        disp([int2str(i), ' ', int2str(ii)])
        
        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);
        
        xLeft = 15;
        yTop = 64;
        xRight = 242;
        yBottom = 192;
        
        for x = xLeft:xRight
            for y = yTop:yBottom
                if Patient(i).DWI(ii).PROI(x,y) == 0
                    prostatePix = 0;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix + Patient(i).DWI(ii).PROI(a,b);
                        end
                    end
                    if prostatePix ~= 0 && usedOutsideEdge(x,y) == 0
                   
                        prostateDWI_xTrain = cat(4, prostateDWI_xTrain, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTrain = [prostateDWI_yTrain,0];
                        for a = max(x-6,1):min(x+6,256)
                            for b = max(y-6,1):min(y+6,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end
                    elseif (usedOutside(x,y) == 0)
                        for a = max(x-30,1):min(x+30,256)
                            for b = max(y-30,1):min(y+30,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                        prostateDWI_xTrain = cat(4, prostateDWI_xTrain, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTrain = [prostateDWI_yTrain,0];
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * Patient(i).DWI(ii).PROI(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        
                        prostateDWI_xTrain = cat(4, prostateDWI_xTrain, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTrain = [prostateDWI_yTrain,1];
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
                        prostateDWI_xTrain = cat(4, prostateDWI_xTrain, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTrain = [prostateDWI_yTrain,1];
                    end
                end
                
            end
        end
    end
end

prostateDWI_yTrain = categorical(prostateDWI_yTrain);

%% Test Data

prostateDWI_yTest = [];
prostateDWI_xTest = [];

for i = 73:74
    numSlices = length(Patient(i).DWI);
    
    for ii = 1:numSlices
        
        slice = adapthisteq(Patient(i).DWI(ii).Slice);
        
        disp([int2str(i), ' ', int2str(ii)])
        
        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);
        
        xLeft = 15;
        yTop = 64;
        xRight = 242;
        yBottom = 192;
        
        for x = xLeft:xRight
            for y = yTop:yBottom
                if Patient(i).DWI(ii).PROI(x,y) == 0
                    prostatePix = 0;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix + Patient(i).DWI(ii).PROI(a,b);
                        end
                    end
                    if prostatePix ~= 0 && usedOutsideEdge(x,y) == 0
                        prostateDWI_xTest = cat(4, prostateDWI_xTest, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTest = [prostateDWI_yTest,0];
                        for a = max(x-6,1):min(x+6,256)
                            for b = max(y-6,1):min(y+6,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end
                    elseif (usedOutside(x,y) == 0)
                        for a = max(x-30,1):min(x+30,256)
                            for b = max(y-30,1):min(y+30,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                        prostateDWI_xTest = cat(4, prostateDWI_xTest, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTest = [prostateDWI_yTest,0];
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * Patient(i).DWI(ii).PROI(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        prostateDWI_xTest = cat(4, prostateDWI_xTest, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTest = [prostateDWI_yTest,1];
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
                        prostateDWI_xTest = cat(4, prostateDWI_xTest, slice(x-14:x+14,y-14:y+14));
                        prostateDWI_yTest = [prostateDWI_yTest,1];
                    end
                end
                
            end
        end
    end
end

prostateDWI_yTest = categorical(prostateDWI_yTest);