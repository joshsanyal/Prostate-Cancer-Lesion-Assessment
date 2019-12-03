function [movingRegistered,movingROIRegistered,movingPROIRegistered] = DWIRegister(patientNum,sliceNum,patients)
%DWIREGISTER using DWI PROI and T2 PROI
%   Detailed explanation goes here

    optimizer = registration.optimizer.OnePlusOneEvolutionary();
    metric = registration.metric.MeanSquares();

    PROImoving = mat2gray(patients(patientNum).DWI(sliceNum).CombinedPROI);
    PROIfixed = mat2gray(patients(patientNum).T2(sliceNum).CombinedPROI);
    
    tformSimilarity = imregtform(PROImoving,PROIfixed,'similarity',optimizer,metric, 'DisplayOptimization',true);

    moving = patients(patientNum).DWI(sliceNum).Slice;
    tumorROI = patients(patientNum).DWI(sliceNum).ROI;
     
     movingRegistered = imwarp(moving,tformSimilarity,'OutputView',imref2d([256 256]));
     movingROIRegistered = imwarp(tumorROI,tformSimilarity,'OutputView',imref2d([256 256]));
     movingPROIRegistered = imwarp(PROImoving,tformSimilarity,'OutputView',imref2d([256 256]));
end

