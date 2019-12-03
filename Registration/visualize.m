%%

figure,
imshowpair(adapthisteq(imresize(Patient(2).T2(1).Slice,1/2)), Patient(2).Registration(1).ADC(1).Slice, 'montage');
%% 

moving = Patient(2).ADC(1).Slice;

figure,
imshow(moving)

fixed = adapthisteq(imresize(Patient(2).T2(1).Slice,1/2));
moving = imhistmatch(moving,fixed);

figure,
imshow(moving)

%% Patient 1 / Slice 1
ADCSeg = bwboundaries(Patient(2).Registration(1).ADC(1).ROI);
DWISeg = bwboundaries(Patient(2).Registration(1).DWI(1).ROI);
T2Seg = bwboundaries(imresize(Patient(2).T2(1).ROI,1/2));

figure,
imshow(adapthisteq(imresize(Patient(2).T2(1).Slice, 1/2)));
title('Registered')
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
hold on
for k = 1:length(T2Seg)
   boundary = T2Seg{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end

ADCSeg2 = bwboundaries(Patient(2).ADC(1).ROI);
DWISeg2 = bwboundaries(Patient(2).DWI(1).ROI);

figure,
imshow(adapthisteq(imresize(Patient(2).T2(1).Slice, 1/2)));
title('Unregistered')
hold on
for k = 1:length(ADCSeg2)
   boundary = ADCSeg2{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end
hold on
for k = 1:length(DWISeg2)
   boundary = DWISeg2{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
hold on
for k = 1:length(T2Seg)
   boundary = T2Seg{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end
%% Patient 3 / Slice 2

ADCSeg = bwboundaries(Patient(3).Registration(1).ADC(2).ROI);
DWISeg = bwboundaries(Patient(3).Registration(1).DWI(2).ROI);
T2Seg = bwboundaries(imresize(Patient(3).T2(2).ROI,1/2));

figure,
imshow(adapthisteq(imresize(Patient(3).T2(2).Slice, 1/2)));
title('Registered')
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
hold on
for k = 1:length(T2Seg)
   boundary = T2Seg{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end

ADCSeg2 = bwboundaries(Patient(3).ADC(2).ROI);
DWISeg2 = bwboundaries(Patient(3).DWI(2).ROI);

figure,
imshow(adapthisteq(imresize(Patient(3).T2(2).Slice, 1/2)));
title('Unregistered')
hold on
for k = 1:length(ADCSeg2)
   boundary = ADCSeg2{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end
hold on
for k = 1:length(DWISeg2)
   boundary = DWISeg2{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
hold on
for k = 1:length(T2Seg)
   boundary = T2Seg{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
end

%% Load Shapes and find points

for patientNum=2:2
    w = size(Patient(patientNum).ADC);
    z = size(Patient(patientNum).T2);
    if (w(2) < z(2)) 
        slices = w(2);
    else
        slices = z(2);
    end
    for sliceNum=1:slices
        
        ROIMoving = Patient(patientNum).ADC(sliceNum).ROI;
        ROIFixed = Patient(patientNum).T2(sliceNum).ROI;
        
        sizeROIMoving = size(ROIMoving);
        sizeROIFixed = size(ROIFixed);
        
        ROIFixed = imresize(ROIFixed, sizeROIMoving(2)/sizeROIFixed(2));

        fixedSeg = bwboundaries(ROIFixed);
        movingSeg = bwboundaries(ROIMoving);
        
        %%

        fixedSegSize = size(fixedSeg{1,1});
        fixedSegSize = fixedSegSize(1);
        
        movingSegSize = size(movingSeg{1,1});
        movingSegSize = movingSegSize(1);
        
        movingPts = movingSeg{1,1};
        fixedPts = fixedSeg{1,1};
        
         [R,T] = icp(fixedPts, movingPts, 100,1000,4,1e-10);
         
         tmatrix = [R(1,1), R(1,2), 0; R(2,1), R(2,2), 0; T(1,1), T(2,1), 1];
          
         tformSimilarity = affine2d(tmatrix);
        
        %% Load images

        moving = Patient(patientNum).ADC(sliceNum).Slice;
        fixed = adapthisteq(Patient(patientNum).T2(sliceNum).Slice);
   
        fixed = imresize(fixed, sizeROIMoving(2)/sizeROIFixed(2));

        %%
%         hi = fixedSeg;
%         hi{1,1} = points;
%         figure, 
%         imshow(fixed)
%         hold on, 
%         for k = 1:length(fixedSeg)
%               boundary = fixedSeg{k};
%               plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
%         end
%         for k = 1:length(hi)
%              boundary = hi{k};
%              plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
%         end
%         for k = 1:length(movingSeg)
%              boundary = movingSeg{k};
%              plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
%         end
        
        %% Plot points on the images
% 
%         figure
%         imshow(moving)
%         title('Select Points')
% 
%         [xMoving,yMoving] = getpts;
% 
%         figure
%         imshow(fixed)
%         title('Select Points')
% 
%         [xFixed,yFixed] = getpts;

        %% Plot points on unregistered image

%         figure,
%         imshowpair(fixed, moving),
%         for i=1:size(xFixed)
%             hold on, plot(xFixed(i),yFixed(i),'r*')
%         end
%         for i=1:size(xMoving)
%             hold on, plot(xMoving(i),yMoving(i),'b*')
%         end

        %% Register the image and plot points

        movingRegistered = imwarp(moving,tformSimilarity,'OutputView',imref2d(size(fixed)));
        movingROIRegistered = imwarp(ROImoving,tformSimilarity,'OutputView',imref2d(size(fixed)));

        figure,
        imshowpair(ROIfixed, ROImoving);
        
        figure,
        imshowpair(movingROIRegistered, ROIfixed);
        
        Patient(patientNum).Registration(2).ADC(sliceNum).Slice = movingRegistered;
        Patient(patientNum).Registration(2).ADC(sliceNum).ROI = movingROIRegistered;
    end
end

%%
for patientNum=1:57
    w = size(Patient(patientNum).DWI);
    z = size(Patient(patientNum).T2);
    if (w(2) < z(2)) 
        hi = w(2);
    else
        hi = z(2);
    end
    for sliceNum=1:hi
        
        ROIMoving = Patient(patientNum).DWI(sliceNum).ROI;
        ROIFixed = Patient(patientNum).T2(sliceNum).ROI;
        
        sizeROIMoving = size(ROIMoving);
        sizeROIFixed = size(ROIFixed);
        
        ROIFixed = imresize(ROIFixed, sizeROIMoving(2)/sizeROIFixed(2));

        fixedSeg = bwboundaries(ROIFixed);
        movingSeg = bwboundaries(ROIMoving);

        a = fixedSeg{1,1}/200;
        b = movingSeg{1,1}/200;

        SDM_FFD_N(a,b);

        b = b * 200;
        ans = ans * 200;

        %% Load images

        moving = Patient(patientNum).DWI(sliceNum).Slice;
        fixed = adapthisteq(Patient(patientNum).T2(sliceNum).Slice);
   
        fixed = imresize(fixed, sizeROIMoving(2)/sizeROIFixed(2));

        %% Find the registration matrix

        tformSimilarity = fitgeotrans(b,ans,'nonreflectivesimilarity'); 

        %% Plot points on the images
% 
%         figure
%         imshow(moving)
%         title('Select Points')
% 
%         [xMoving,yMoving] = getpts;
% 
%         figure
%         imshow(fixed)
%         title('Select Points')
% 
%         [xFixed,yFixed] = getpts;

        %% Plot points on unregistered image

%         figure,
%         imshowpair(fixed, moving),
%         for i=1:size(xFixed)
%             hold on, plot(xFixed(i),yFixed(i),'r*')
%         end
%         for i=1:size(xMoving)
%             hold on, plot(xMoving(i),yMoving(i),'b*')
%         end

        %% Register the image and plot points

        movingRegistered = imwarp(moving,tformSimilarity,'OutputView',imref2d(size(fixed)));
        movingROIRegistered = imwarp(ROImoving,tformSimilarity,'OutputView',imref2d(size(fixed)));
 
%          figure,
%          imshowpair(movingRegisteredRigid, fixed)
%          title('Registered')
%          for i=1:size(xFixed)
%                 hold on, plot(xFixed(i),yFixed(i),'r*')
%          end
%         for i=1:size(xMoving)
%             [a, b] = transformPointsForward(tformSimilarity,xMoving(i),yMoving(i));
%             hold on, plot(a,b,'b*')
%         end

        Patient(patientNum).Registration(2).DWI(sliceNum).Slice = movingRegistered;
        Patient(patientNum).Registration(2).DWI(sliceNum).ROI = movingROIRegistered;
    end
end
%% Save the image
save('Patient_57.mat','Patient') 