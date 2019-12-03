function [smallHeatmap,largeHeatmap,combinedHeatmap] = ADCHeatmapRegister(patientNum,sliceNum, patients)
%ADCREGISTER Using the heatmaps to produce the registration
%   Detailed explanation goes here

    optimizer = registration.optimizer.OnePlusOneEvolutionary();
    metric = registration.metric.MeanSquares();

    ROImoving = mat2gray(patients(patientNum).ADC(sliceNum).PROI);
    ROIfixed = mat2gray(patients(patientNum).T2(sliceNum).PROI);

    sizeROIMoving = size(ROImoving);
    sizeROIFixed = size(ROIfixed);

    ROIfixed = imresize(ROIfixed, sizeROIMoving(2)/sizeROIFixed(2));

    moving = patients(patientNum).ADC(sliceNum).Slice;
    fixed = adapthisteq(patients(patientNum).T2(sliceNum).Slice);

    fixed = imresize(fixed, sizeROIMoving(2)/sizeROIFixed(2));

    tumorROI = patients(patientNum).ADC(sliceNum).ROI;
    
    tformSimilarity = imregtform(ROImoving,ROIfixed,'rigid',optimizer,metric, 'DisplayOptimization',true);

     smallHeatmap = imwarp(patients(patientNum).ADC(sliceNum).ProstateHeatmap,tformSimilarity,'OutputView',imref2d(size(fixed)));
     largeHeatmap = imwarp(patients(patientNum).ADC(sliceNum).EdgeProstateHeatmap,tformSimilarity,'OutputView',imref2d(size(fixed)));
     combinedHeatmap = imwarp(patients(patientNum).ADC(sliceNum).CombinedProstateHeatmap,tformSimilarity,'OutputView',imref2d(size(fixed)));
end

