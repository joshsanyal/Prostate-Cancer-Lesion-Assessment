function [movingRegistered,movingROIRegistered,movingPROIRegistered] = ADCRegister(patientNum,sliceNum, patients)
%ADCREGISTER using ADC PROI and T2 PROI
%   Detailed explanation goes here

    optimizer = registration.optimizer.OnePlusOneEvolutionary();
    metric = registration.metric.MeanSquares();

    PROImoving = mat2gray(patients(patientNum).ADC(sliceNum).CombinedPROI);
    PROIfixed = mat2gray(patients(patientNum).T2(sliceNum).CombinedPROI);
    
    tformSimilarity = imregtform(PROImoving,PROIfixed,'similarity',optimizer,metric, 'DisplayOptimization',true);

    moving = patients(patientNum).ADC(sliceNum).Slice;
    tumorROI = patients(patientNum).ADC(sliceNum).ROI;
     
     movingRegistered = imwarp(moving,tformSimilarity,'OutputView',imref2d([256 256]));
     movingROIRegistered = imwarp(tumorROI,tformSimilarity,'OutputView',imref2d([256 256]));
     movingPROIRegistered = imwarp(PROImoving,tformSimilarity,'OutputView',imref2d([256 256]));
end

