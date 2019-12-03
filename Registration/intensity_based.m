%load("Patient_57.mat")

moving = Patient(3).ADC(2).Slice;
fixed = adapthisteq(imresize(Patient(3).T2(2).Slice,1/2));
moving2 = Patient(3).DWI(2).Slice;
roiMoving2 = Patient(3).DWI(2).ROI;
roiMoving = Patient(3).ADC(2).ROI;
roiFixed = imresize(Patient(3).T2(2).ROI,1/2);

moving = imhistmatch(moving,fixed);
moving2 = imhistmatch(moving2,fixed);

optimizer = registration.optimizer.RegularStepGradientDescent();
metric = registration.metric.MattesMutualInformation();

 
 tformADC = imregtform(moving,fixed,'affine',optimizer,metric, 'DisplayOptimization',true);
 tformDWI = imregtform(moving2,fixed,'affine',optimizer,metric, 'DisplayOptimization',true);
 
 Rfixed = imref2d(size(fixed));
 
 movedROI = imwarp(roiMoving,tformADC,'OutputView',Rfixed);
 movedROI2 = imwarp(roiMoving2,tformDWI,'OutputView',Rfixed); 
 
  T2Seg = bwboundaries(roiFixed);
  ADCSeg = bwboundaries(roiMoving);
  ADCSegMoved = bwboundaries(movedROI);
  DWISeg = bwboundaries(roiMoving2);
  DWISegMoved = bwboundaries(movedROI2);
  %% 
  
 figure,
 imshow(fixed)
title('Unregistered')
    hold on
    for k = 1:length(T2Seg)
       boundary = T2Seg{k};
       plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
    end
    hold on
    for k = 1:length(ADCSeg)
       boundary = ADCSeg{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
    end
    hold on
    for k = 1:length(DWISeg)
       boundary = DWISeg{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
    legend('T2 ROI', 'ADC ROI', 'DWI ROI');
  
 figure,
 imshow(fixed)
title('Intensity-Based Registration (RSGD + MMI)')
    hold on
    for k = 1:length(T2Seg)
       boundary = T2Seg{k};
       plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
    end
    hold on
    for k = 1:length(ADCSegMoved)
       boundary = ADCSegMoved{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
    end
    hold on
    for k = 1:length(DWISegMoved)
       boundary = DWISegMoved{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
    legend('T2 ROI', 'ADC ROI', 'DWI ROI');
    
    
    %% 
    
    figure,
    imshow(fixed)
    title('Patient 3 (Slice 2)')
     hold on
    for k = 1:length(T2Seg)
       boundary = T2Seg{k};
       plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
    end
    hold on
    for k = 1:length(ADCSeg)
       boundary = ADCSeg{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
    end
    hold on
    for k = 1:length(DWISeg)
       boundary = DWISeg{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
    legend('T2 ROI', 'ADC ROI', 'DWI ROI');