NewFeaturesNormalized = FeaturesNormalized(:,[1:10,14,18:120,125,128:141,184:212,216,221:334,339,342:355,398:425,430,432:530,534,538:551,594:612]);
NewVaryingFeatures = varyingFeatures(:,[1:10,14,18:120,125,128:141,184:212,216,221:334,339,342:355,398:425,430,432:530,534,538:551,594:612]);

%% 

NewFeaturesNormalized = NewFeaturesNormalized(:,[2:148,150:307,309:459]);
NewVaryingFeatures = NewVaryingFeatures(:,[2:148,150:307,309:459]);

%% T2

A = [];
P = [];
R = [];

for i=1:74
    
    if i == 13 || i == 32 || i == 51
        i = i + 1;
    end
    
    numSlices = size(Patient(i).T2);
    numSlices = numSlices(2);
    maxArea = 0;
    bestPeri = 0;
    bestSlice = 0;
    for j=1:numSlices
        area = regionprops(Patient(i).T2(j).ROI,'Area', 'Perimeter');
        areaCorrect = size(area);
        areaCorrect = areaCorrect(1);
        if areaCorrect == 1 && area.Area > maxArea
            maxArea = area.Area;
            bestPeri = area.Perimeter;
            bestSlice = j;
        elseif areaCorrect == 255 && area(255).Area > maxArea
            maxArea = area(255).Area;
            bestPeri = area(255).Perimeter;
            bestSlice = j;
        end
    end
    
    ROI = imresize(Patient(i).T2(bestSlice).ROI, 1/2);
    Slice = adapthisteq(imresize(Patient(i).T2(bestSlice).Slice, 1/2));
    
    A = [A; maxArea];
    P = [P; bestPeri];
    R = [R; Roughness(ROI)];
    
end

A = normalize(A);
P = normalize(P);
R = normalize(R);

NewFeaturesNormalized = horzcat(NewFeaturesNormalized, A, P, R);

%% DWI

A = [];
P = [];
R = [];

for i=1:74
    
    if i == 13 || i == 32 || i == 51
        i = i + 1;
    end
    
    disp(i);
    
    numSlices = size(Patient(i).DWI);
    numSlices = numSlices(2);
    maxArea = 0;
    bestPeri = 0;
    bestSlice = 0;
    for j=1:numSlices
        area = regionprops(Patient(i).DWI(j).ROI,'Area', 'Perimeter');
        areaCorrect = size(area);
        areaCorrect = areaCorrect(1);
        if areaCorrect == 1 && area.Area > maxArea
            maxArea = area.Area;
            bestPeri = area.Perimeter;
            bestSlice = j;
        elseif areaCorrect == 255 && area(255).Area > maxArea
            maxArea = area(255).Area;
            bestPeri = area(255).Perimeter;
            bestSlice = j;
        end
    end
    
    ROI = Patient(i).DWI(bestSlice).ROI;
    Slice = Patient(i).DWI(bestSlice).Slice;
    
    A = [A; maxArea];
    P = [P; bestPeri];
    R = [R; Roughness(ROI)];
    
end

A = normalize(A);
P = normalize(P);
R = normalize(R);

NewFeaturesNormalized = horzcat(NewFeaturesNormalized, A, P, R);

%% ADC

A = [];
P = [];
R = [];

for i=1:74
    
    if i == 13 || i == 32 || i == 51
        i = i + 1;
    end
    
    disp(i);
    
    numSlices = size(Patient(i).ADC);
    numSlices = numSlices(2);
    maxArea = 0;
    bestPeri = 0;
    bestSlice = 0;
    for j=1:numSlices
        area = regionprops(Patient(i).ADC(j).ROI,'Area', 'Perimeter');
        areaCorrect = size(area);
        areaCorrect = areaCorrect(1);
        if areaCorrect == 1 && area.Area > maxArea
            maxArea = area.Area;
            bestPeri = area.Perimeter;
            bestSlice = j;
        elseif areaCorrect == 255 && area(255).Area > maxArea
            maxArea = area(255).Area;
            bestPeri = area(255).Perimeter;
            bestSlice = j;
        end
    end
    
    ROI = Patient(i).ADC(bestSlice).ROI;
    Slice = Patient(i).ADC(bestSlice).Slice;
    
    A = [A; maxArea];
    P = [P; bestPeri];
    R = [R; Roughness(ROI)];
    
end

A = normalize(A);
P = normalize(P);
R = normalize(R);

NewFeaturesNormalized = horzcat(NewFeaturesNormalized, A, P, R);
