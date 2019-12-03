%% T2
for i=1:57  
    try
        if (~any(structfun(@isempty, Patient(i).Test)))
            disp(i);

            ROI = Patient(i).Test.ROI;
            Slice = Patient(i).Test.T2;
            prop = regionprops(ROI,'Area', 'Perimeter');

            feature(i).T2.Roughness = Roughness(ROI);
            feature(i).T2.RDS = radialDistSig(ROI);
            feature(i).T2.Pixvalue = PixValue(Slice,ROI);
            feature(i).T2.LBP = LBP(Slice,ROI);
            feature(i).T2.InsM = InsM(Slice,ROI);
            feature(i).T2.HistogramEdge = HistogramEdge(Slice,ROI,32);
            feature(i).T2.HistogramLesion = HistogramCount(Slice,ROI,32);
            feature(i).T2.Entropy = Ent(Slice,ROI);
            feature(i).T2.Eccent = eccentricity(ROI);
            feature(i).T2.Diff = [Diff(Slice,ROI,1), Diff(Slice,ROI,10)];
            feature(i).T2.Com = compactness(ROI);
            feature(i).T2.GLCM = [Hara(Slice,ROI,1), Hara(Slice,ROI,10)];
            feature(i).T2.EdgeSharpness = edgeSharpness(Slice,ROI);
            feature(i).T2.Area = prop.Area;
            feature(i).T2.Perimeter = prop.Perimeter;
        end
    end
end
%% ADC
for i=1:57
    
    try
        if (~any(structfun(@isempty, Patient(i).Test)))
            disp(i);

            ROI = Patient(i).Test.ROI;
            Slice = Patient(i).Test.ADC;
            prop = regionprops(ROI,'Area', 'Perimeter');

            feature(i).ADC.Roughness = Roughness(ROI);
            feature(i).ADC.RDS = radialDistSig(ROI);
            feature(i).ADC.Pixvalue = PixValue(Slice,ROI);
            feature(i).ADC.LBP = LBP(Slice,ROI);
            feature(i).ADC.InsM = InsM(Slice,ROI);
            feature(i).ADC.HistogramEdge = HistogramEdge(Slice,ROI,32);
            feature(i).ADC.HistogramLesion = HistogramCount(Slice,ROI,32);
            feature(i).ADC.Entropy = Ent(Slice,ROI);
            feature(i).ADC.Eccent = eccentricity(ROI);
            feature(i).ADC.Diff = [Diff(Slice,ROI,1), Diff(Slice,ROI,10)];
            feature(i).ADC.Com = compactness(ROI);
            feature(i).ADC.GLCM = [Hara(Slice,ROI,1), Hara(Slice,ROI,10)];
            feature(i).ADC.EdgeSharpness = edgeSharpness(Slice,ROI);
            feature(i).ADC.Area = prop.Area;
            feature(i).ADC.Perimeter = prop.Perimeter;
        end
    end
end


%% DWI
for i=1:57
    
    try
        if (~any(structfun(@isempty, Patient(i).Test)))
            disp(i);

            ROI = Patient(i).Test.ROI;
            Slice = Patient(i).Test.DWI;

            prop = regionprops(ROI,'Area', 'Perimeter');

            feature(i).DWI.Roughness = Roughness(ROI);
            feature(i).DWI.RDS = radialDistSig(ROI);
            feature(i).DWI.Pixvalue = PixValue(Slice,ROI);
            feature(i).DWI.LBP = LBP(Slice,ROI);
            feature(i).DWI.InsM = InsM(Slice,ROI);
            feature(i).DWI.HistogramEdge = HistogramEdge(Slice,ROI,32);
            feature(i).DWI.HistogramLesion = HistogramCount(Slice,ROI,32);
            feature(i).DWI.Entropy = Ent(Slice,ROI);
            feature(i).DWI.Eccent = eccentricity(ROI);
            feature(i).DWI.Diff = [Diff(Slice,ROI,1), Diff(Slice,ROI,10)];
            feature(i).DWI.Com = compactness(ROI);
            feature(i).DWI.GLCM = [Hara(Slice,ROI,1), Hara(Slice,ROI,10)];
            feature(i).DWI.EdgeSharpness = edgeSharpness(Slice,ROI);
            feature(i).DWI.Area = prop.Area;
            feature(i).DWI.Perimeter = prop.Perimeter;
        end
    end
end
