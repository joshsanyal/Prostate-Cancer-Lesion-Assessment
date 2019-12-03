ADC = Patient(2).ADC(1).Slice;
ADCROI = Patient(2).ADC(1).ROI;
DWI = Patient(2).DWI(1).Slice;
DWIROI = Patient(2).DWI(1).ROI;
T2 = adapthisteq(imresize(Patient(2).T2(1).Slice,1/2));
%% 

Options.Similarity = 'm';
Options.Registration = 'nonrigid';
[Ireg,Bx,By,Fx,Fy] = register_images(ADC,T2,Options);

[Ireg2,Bx2,By2,Fx2,Fy2] = register_images(DWI,T2,Options);

%% 

figure,
imshow(T2)

ADCROI2=movepixels(ADCROI,Bx,By,[], 3);
DWIROI2=movepixels(DWIROI,Bx2,By2,[], 3);

ADCSeg = bwboundaries(ADCROI2);
T2Seg = bwboundaries(imresize(Patient(2).T2(1).ROI,1/2));
DWISeg = bwboundaries(DWIROI2);

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
