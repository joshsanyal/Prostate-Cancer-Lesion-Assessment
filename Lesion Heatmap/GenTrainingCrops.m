%% Training Data (need to separate low and high gleason score, test for high, if scattered test for low)

lesionAll_yTrain = [];
lesionAll_xTrain = [];
label = 0;

for i = 70:77
    numSlices = length(Patient(i).PRegistration.ADC);
    if (i ~= 6 && i ~= 12 && i ~= 13 && i ~= 24 && i ~= 27 && i ~= 32 && i ~= 38 && i ~= 44)
        if (Patient(i).truth(1) == 'H')
            label = 2;
        else 
            label = 1;
        end
        
        for ii = 1:numSlices 

            ADCslice = adapthisteq(Patient(i).PRegistration.ADC(ii).Slice);
            DWIslice = adapthisteq(Patient(i).PRegistration.DWI(ii).Slice);
            T2slice = imresize(adapthisteq(Patient(i).T2(ii).Slice),1/2);
            AllROI = zeros(256,256);
            for a = 1:256
                for b = 1:256
                    if (Patient(i).PRegistration.ADC(ii).ROI(a,b) ~= 0 || Patient(i).PRegistration.DWI(ii).ROI(a,b) ~= 0)
                        AllROI(a,b) = label;
                    end
                end
            end

            disp([int2str(i), ' ', int2str(ii)])

            usedOutside = zeros(256,256);
            usedOutsideEdge = zeros(256,256);
            usedOutsideFar = zeros(256,256);
            usedInside = zeros(256,256);
            usedInsideEdge = zeros(256,256);

            T2PROI = Patient(i).PRegistration.ADC(ii).PROI;
            box = regionprops(T2PROI,'BoundingBox');
            box = box.BoundingBox;

            xLeft = round(box(1)) - 30;
            yTop = round(box(2)) - 30;
            xRight = round(box(1)) + box(3) + 30;
            yBottom = round(box(2)) + box(4) + 30;

            for x = xLeft:xRight
                for y = yTop:yBottom
                    if AllROI(x,y) == 0
                        prostatePix = 0;
                        if (usedOutsideEdge(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                            for a = max(x-3,1):min(x+3,256)
                                for b = max(y-3,1):min(y+3,256)
                                    prostatePix = prostatePix + AllROI(a,b);
                                end
                            end
                        end

                        outsidePix = 0;
                        if (usedOutsideFar(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                            for a = max(x-10,1):min(x+10,256)
                                for b = max(y-10,1):min(y+10,256)
                                    outsidePix = outsidePix + AllROI(a,b);
                                end
                            end
                        end

                        if prostatePix ~= 0
                            lesionAll_xTrain = cat(4, lesionAll_xTrain, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                            lesionAll_yTrain = [lesionAll_yTrain;0];
                            for a = max(x-5,1):min(x+5,256)
                                for b = max(y-5,1):min(y+5,256)
                                    usedOutsideEdge(a,b) = 1;
                                end
                            end
                        elseif outsidePix ~= 0
                            lesionAll_xTrain = cat(4, lesionAll_xTrain, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                            lesionAll_yTrain = [lesionAll_yTrain;0];
                            for a = max(x-9,1):min(x+9,256)
                                for b = max(y-9,1):min(y+9,256)
                                    usedOutsideFar(a,b) = 1;
                                end
                            end                             
                        elseif (usedOutside(x,y) == 0)
                            lesionAll_xTrain = cat(4, lesionAll_xTrain, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                            lesionAll_yTrain = [lesionAll_yTrain;0];
                            for a = max(x-48,1):min(x+48,256)
                                for b = max(y-48,1):min(y+48,256)
                                    usedOutside(a,b) = 1;
                                end
                            end
                        end
                    else
                        prostatePix = 1;
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                prostatePix = prostatePix * AllROI(a,b);
                            end
                        end
                        if prostatePix == 0 && usedInsideEdge(x,y) == 0
                            lesionAll_xTrain = cat(4, lesionAll_xTrain, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                            lesionAll_yTrain = [lesionAll_yTrain;label];
                            for a = max(x-2,1):min(x+1,256)
                                for b = max(y-2,1):min(y+1,256)
                                    usedInsideEdge(a,b) = 1;
                                end
                            end
                        elseif (usedInside(x,y) == 0)
                            for a = max(x-5,1):min(x+5,256)
                                for b = max(y-5,1):min(y+5,256)
                                    usedInside(a,b) = 1;
                                end
                            end
                            lesionAll_xTrain = cat(4, lesionAll_xTrain, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                            lesionAll_yTrain = [lesionAll_yTrain;label];
                        end
                    end

                end
            end
        end
    end
end

lesionAll_yTrain = categorical(lesionAll_yTrain);

%% Test Data

lesionAll_yTest = [];
lesionAll_xTest = [];

for i = 70:72
    numSlices = length(Patient(i).PRegistration.ADC);
    if (Patient(i).truth(1) == 'H')
        label = 2;
    else
        label = 1;
    end
    for ii = 1:numSlices

        ADCslice = adapthisteq(Patient(i).PRegistration.ADC(ii).Slice);
        DWIslice = adapthisteq(Patient(i).PRegistration.DWI(ii).Slice);
        T2slice = imresize(adapthisteq(Patient(i).T2(ii).Slice),1/2);
        AllROI = zeros(256,256);
        for a = 1:256
            for b = 1:256
                if (Patient(i).PRegistration.ADC(ii).ROI(a,b) ~= 0 || Patient(i).PRegistration.DWI(ii).ROI(a,b) ~= 0)
                    AllROI(a,b) = 1;
                end
            end
        end

        disp([int2str(i), ' ', int2str(ii)])

        usedOutside = zeros(256,256);
        usedOutsideEdge = zeros(256,256);
        usedOutsideFar = zeros(256,256);
        usedInside = zeros(256,256);
        usedInsideEdge = zeros(256,256);

        T2PROI = imresize(Patient(i).T2(ii).PROI,1/2);
        box = regionprops(T2PROI,'BoundingBox');

        xLeft = round(box.BoundingBox(1)) - 30;
        yTop = round(box.BoundingBox(2)) - 30;
        xRight = round(box.BoundingBox(1)) + box.BoundingBox(3) + 30;
        yBottom = round(box.BoundingBox(2)) + box.BoundingBox(4) + 30;

        for x = xLeft:xRight
            for y = yTop:yBottom
                if AllROI(x,y) == 0

                    prostatePix = 0;
                    if (usedOutsideEdge(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                        for a = max(x-3,1):min(x+3,256)
                            for b = max(y-3,1):min(y+3,256)
                                prostatePix = prostatePix + AllROI(a,b);
                            end
                        end
                    end

                    outsidePix = 0;
                    if (usedOutsideFar(x,y) == 0 && x > 96 && x < 161 && y > 107 && y < 150)
                        for a = max(x-10,1):min(x+10,256)
                            for b = max(y-10,1):min(y+10,256)
                                outsidePix = outsidePix + AllROI(a,b);
                            end
                        end
                    end

                    if prostatePix ~= 0
                        lesionAll_xTest = cat(4, lesionAll_xTest, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                        lesionAll_yTest = [lesionAll_yTest;0];
                        for a = max(x-5,1):min(x+5,256)
                            for b = max(y-5,1):min(y+5,256)
                                usedOutsideEdge(a,b) = 1;
                            end
                        end
                    elseif outsidePix ~= 0
                        lesionAll_xTest = cat(4, lesionAll_xTest, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                        lesionAll_yTest = [lesionAll_yTest;0];
                        for a = max(x-9,1):min(x+9,256)
                            for b = max(y-9,1):min(y+9,256)
                                usedOutsideFar(a,b) = 1;
                            end
                        end
                    elseif (usedOutside(x,y) == 0)
                        lesionAll_xTest = cat(4, lesionAll_xTest, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                        lesionAll_yTest = [lesionAll_yTest;0];
                        for a = max(x-48,1):min(x+48,256)
                            for b = max(y-48,1):min(y+48,256)
                                usedOutside(a,b) = 1;
                            end
                        end
                    end
                else
                    prostatePix = 1;
                    for a = max(x-3,1):min(x+3,256)
                        for b = max(y-3,1):min(y+3,256)
                            prostatePix = prostatePix * AllROI(a,b);
                        end
                    end
                    if prostatePix == 0 && usedInsideEdge(x,y) == 0
                        lesionAll_xTest = cat(4, lesionAll_xTest, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                        lesionAll_yTest = [lesionAll_yTest;label];
                        for a = max(x-2,1):min(x+1,256)
                            for b = max(y-2,1):min(y+1,256)
                                usedInsideEdge(a,b) = 1;
                            end
                        end
                    elseif (usedInside(x,y) == 0)
                        for a = max(x-5,1):min(x+5,256)
                            for b = max(y-5,1):min(y+5,256)
                                usedInside(a,b) = 1;
                            end
                        end
                        lesionAll_xTest = cat(4, lesionAll_xTest, cat(3,DWIslice(x-5:x+5,y-5:y+5),ADCslice(x-5:x+5,y-5:y+5),T2slice(x-5:x+5,y-5:y+5),AllROI(x-5:x+5,y-5:y+5)));
                        lesionAll_yTest = [lesionAll_yTest;label];
                    end
                end

            end
        end
    end
end

lesionAll_yTest = categorical(lesionAll_yTest);

%% 

counter = 0;
for i=1:77
    if (Patient(i).truth(1) == 'H')
        counter = counter + 1;
    end
end
