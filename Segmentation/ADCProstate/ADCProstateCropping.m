%% Training Data

prostateADC_yTrain = [];
prostateADC_xTrain = [];

%% Need to collect more about edges (inside and out) and other nearby structures, also use adapthisteq
for i = 58:72
    numSlices = length(Patient(i).ADC);
    
    for ii = 1:numSlices 
        
        slice = adapthisteq(Patient(i).ADC(ii).Slice);
        
        disp([int2str(i), ' ', int2str(ii)])
        
        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedOutsideFar = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);
        
        xLeft = 21;
        yTop = 64;
        xRight = 235;
        yBottom = 192;
        
        for x = xLeft:xRight
            for y = yTop:yBottom
                if Patient(i).ADC(ii).PROI(x,y) == 0
                    
                    prostatePix = 0;
                    if (usedOutsideEdge(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                prostatePix = prostatePix + Patient(i).ADC(ii).PROI(a,b);
                            end
                        end
                    end
                    
                    outsidePix = 0;
                    if (usedOutsideFar(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                        for a = max(x-20,1):min(x+20,256)
                            for b = max(y-20,1):min(y,256)
                                outsidePix = outsidePix + Patient(i).ADC(ii).PROI(a,b);
                            end
                        end
                    end
                    
                    if prostatePix ~= 0
                        prostateADC_xTrain = cat(4, prostateADC_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTrain = [prostateADC_yTrain;0];
                        for a = max(x-2,1):min(x+2,256)
                            for b = max(y-2,1):min(y+2,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end
                    elseif outsidePix ~= 0
                        prostateADC_xTrain = cat(4, prostateADC_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTrain = [prostateADC_yTrain;0];
                        for a = max(x-7,1):min(x+7,256)
                            for b = max(y-7,1):min(y+7,256)
                                usedOutsideFar(a,b) = 1;
                            end
                        end                             
                    elseif (usedOutside(x,y) == 0)
                        for a = max(x-60,1):min(x+60,256)
                            for b = max(y-60,1):min(y+60,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                        prostateADC_xTrain = cat(4, prostateADC_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTrain = [prostateADC_yTrain;0];
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * Patient(i).ADC(ii).PROI(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        prostateADC_xTrain = cat(4, prostateADC_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTrain = [prostateADC_yTrain;1];
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
                        prostateADC_xTrain = cat(4, prostateADC_xTrain, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTrain = [prostateADC_yTrain;1];
                    end
                end
                
            end
        end
    end
end

prostateADC_yTrain = categorical(prostateADC_yTrain);

%% Test Data

prostateADC_yTest = [];
prostateADC_xTest = [];

for i = 73:77
    numSlices = length(Patient(i).ADC);
    
    for ii = 1:numSlices
        
        slice = adapthisteq(Patient(i).ADC(ii).Slice);
        
        disp([int2str(i), ' ', int2str(ii)])
        
        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedOutsideFar = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);
        
        xLeft = 21;
        yTop = 64;
        xRight = 235;
        yBottom = 192;
        
        for x = xLeft:xRight
            for y = yTop:yBottom
                if Patient(i).ADC(ii).PROI(x,y) == 0
                    
                    prostatePix = 0;
                    if (usedOutsideEdge(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                prostatePix = prostatePix + Patient(i).ADC(ii).PROI(a,b);
                            end
                        end
                    end
                    
                    outsidePix = 0;
                    if (usedOutsideFar(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                        for a = max(x-20,1):min(x+20,256)
                            for b = max(y-20,1):min(y,256)
                                outsidePix = outsidePix + Patient(i).ADC(ii).PROI(a,b);
                            end
                        end
                    end
                    
                    if prostatePix ~= 0
                        prostateADC_xTest = cat(4, prostateADC_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTest = [prostateADC_yTest;0];
                        for a = max(x-2,1):min(x+2,256)
                            for b = max(y-2,1):min(y+2,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end
                    elseif outsidePix ~= 0
                        prostateADC_xTest = cat(4, prostateADC_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTest = [prostateADC_yTest;0];
                        for a = max(x-7,1):min(x+7,256)
                            for b = max(y-7,1):min(y+7,256)
                                usedOutsideFar(a,b) = 1;
                            end
                        end
                    elseif (usedOutside(x,y) == 0)
                        for a = max(x-60,1):min(x+60,256)
                            for b = max(y-60,1):min(y+60,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                        prostateADC_xTest = cat(4, prostateADC_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTest = [prostateADC_yTest;0];
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * Patient(i).ADC(ii).PROI(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        prostateADC_xTest = cat(4, prostateADC_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTest = [prostateADC_yTest;1];
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
                        prostateADC_xTest = cat(4, prostateADC_xTest, slice(x-7:x+7,y-7:y+7));
                        prostateADC_yTest = [prostateADC_yTest;1];
                    end
                end
                
            end
        end
    end
end

prostateADC_yTest = categorical(prostateADC_yTest);