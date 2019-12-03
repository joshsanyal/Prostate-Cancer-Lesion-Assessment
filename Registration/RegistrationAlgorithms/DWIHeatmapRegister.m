function [smallHeatmap,largeHeatmap,combinedHeatmap] = DWIHeatmapRegister(patientNum,sliceNum,patients)
%ADCREGISTER using the heatmaps to register
%   Detailed explanation goes here

    optimizer = registration.optimizer.OnePlusOneEvolutionary();
    metric = registration.metric.MeanSquares();

    ROImoving = mat2gray(patients(patientNum).DWI(sliceNum).PROI);
    ROIfixed = mat2gray(patients(patientNum).T2(sliceNum).PROI);

    sizeROIMoving = size(ROImoving);
    sizeROIFixed = size(ROIfixed);

    ROIfixed = imresize(ROIfixed, sizeROIMoving(2)/sizeROIFixed(2));

    moving = patients(patientNum).DWI(sliceNum).Slice;
    fixed = adapthisteq(patients(patientNum).T2(sliceNum).Slice);

    fixed = imresize(fixed, sizeROIMoving(2)/sizeROIFixed(2));
    
    tumorROI = patients(patientNum).DWI(sliceNum).ROI;

    tformSimilarity = imregtform(ROImoving,ROIfixed,'rigid',optimizer,metric, 'DisplayOptimization',true);

     smallHeatmap = imwarp(patients(patientNum).DWI(sliceNum).ProstateHeatmap,tformSimilarity,'OutputView',imref2d(size(fixed)));
     largeHeatmap = imwarp(patients(patientNum).DWI(sliceNum).EdgeProstateHeatmap,tformSimilarity,'OutputView',imref2d(size(fixed)));
     combinedHeatmap = imwarp(patients(patientNum).DWI(sliceNum).CombinedProstateHeatmap,tformSimilarity,'OutputView',imref2d(size(fixed)));
end

