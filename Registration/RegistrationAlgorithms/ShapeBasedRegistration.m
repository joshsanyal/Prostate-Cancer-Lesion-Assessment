function [movingImageRegistered,movingROIRegistered,movingPROIRegistered] = ShapeBasedRegistration(fixedPROI,movingPROI,movingImage,movingROI)
% Inputs
%   fixedPROI: The binary image of the fixed image's prostate
%   movingPROI: The binary image of the moving image's prostate
%   movingImage: The image to be registered
%   movingROI: The binary image of the moving image's lesion
%
% Outputs
%   movingImageRegistered: The registered moving image
%   movingROIRegistered: The registered lesion ROI
%   movingPROIRegistered: The registered prostate ROI

    optimizer = registration.optimizer.OnePlusOneEvolutionary();
    metric = registration.metric.MeanSquares();
    fixedPROI = imresize(fixedPROI, size(movingPROI));
    
    tformSimilarity = imregtform(movingPROI,fixedPROI,'similarity',optimizer,metric);
    
    movingImageRegistered = imwarp(movingImage,tformSimilarity,'OutputView',imref2d(size(movingImage)));
    movingROIRegistered = imwarp(movingROI,tformSimilarity,'OutputView',imref2d(size(movingROI)));
    movingPROIRegistered = imwarp(movingPROI,tformSimilarity,'OutputView',imref2d(size(movingPROI)));

end