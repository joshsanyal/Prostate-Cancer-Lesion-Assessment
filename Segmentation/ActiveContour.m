PatientNum = 58;

%% DWI

DWILesionSeg = bwboundaries(Patient(PatientNum).PRegistration.DWI(1).ROI);
 
figure,
imshow(Patient(PatientNum).PRegistration.DWI(1).Slice);
hold on
for k = 1:length(DWILesionSeg)
   boundary = DWILesionSeg{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

Mask = zeros(256,256);
centroid = regionprops(Patient(PatientNum).PRegistration.DWI(1).ROI,'centroid');
if (length(centroid) == 255)
   centroidX = centroid(255).Centroid(1);
   centroidY = centroid(255).Centroid(2);
else
   centroidX = centroid.Centroid(1);
   centroidY = centroid.Centroid(2);
end

Mask(ceil(centroidY),round(centroidX)) = 1;
Mask(ceil(centroidY)-1,round(centroidX)) = 1;

newROI = activecontour(Patient(PatientNum).PRegistration.DWI(1).Slice,Mask,10,'Chan-Vese');

newSeg = bwboundaries(newROI);

figure,
imshow(Patient(PatientNum).PRegistration.DWI(1).Slice);
hold on
for k = 1:length(newSeg)
   boundary = newSeg{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

%% ADC

ADCLesionSeg = bwboundaries(Patient(PatientNum).PRegistration.ADC(1).ROI);
 
figure,
imshow(Patient(PatientNum).PRegistration.ADC(1).Slice);
hold on
for k = 1:length(ADCLesionSeg)
   boundary = ADCLesionSeg{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end

Mask = zeros(256,256);
centroid = regionprops(Patient(PatientNum).PRegistration.ADC(1).ROI,'centroid');
if (length(centroid) == 255)
   centroidX = centroid(255).Centroid(1);
   centroidY = centroid(255).Centroid(2);
else
   centroidX = centroid.Centroid(1);
   centroidY = centroid.Centroid(2);
end

Mask(round(centroidY)-1,round(centroidX)) = 1;
Mask(round(centroidY),round(centroidX)) = 1;

newROI = activecontour(Patient(PatientNum).PRegistration.ADC(1).Slice,Mask,10,'Chan-Vese');

newSeg = bwboundaries(newROI);

figure,
imshow(Patient(PatientNum).PRegistration.ADC(1).Slice);
hold on
for k = 1:length(newSeg)
   boundary = newSeg{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end