%% Patients
% 5, 16, 19, 25
for c=19:19
    ADCSeg = bwboundaries(Patient(c).ADC(1).CombinedPROI);
    DWISeg = bwboundaries(Patient(c).DWI(1).CombinedPROI);
    T2Seg = bwboundaries(Patient(c).T2(1).CombinedPROI);
    
    figure,
    imshow(adapthisteq(imresize(Patient(c).T2(1).Slice,1/2)));
    title('Before Registration')
    hold on
    for k = 1:length(ADCSeg)
       boundary = ADCSeg{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 3)
    end
    hold on
    for k = 1:length(DWISeg)
       boundary = DWISeg{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3)
    end
    hold on
    for k = 1:length(T2Seg)
       boundary = T2Seg{k};
       plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3)
    end
    legend('ADC Prostate', 'DWI Prostate', 'T2 Prostate');

    ADCSeg2 = bwboundaries(Patient(c).PRegistration.ADC(1).PROI);
    DWISeg2 = bwboundaries(Patient(c).PRegistration.DWI(1).PROI);
    %T2Seg = bwboundaries(imresize(Patient(c).T2(1).ROI,1/2));
    
    figure,
    imshow(adapthisteq(imresize(Patient(c).T2(1).Slice,1/2)));    
    title('Shape-Based Registration')
    hold on
    for k = 1:length(ADCSeg2)
       boundary = ADCSeg2{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 3)
    end
    hold on
    for k = 1:length(DWISeg2)
       boundary = DWISeg2{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3)
    end
    hold on
    for k = 1:length(T2Seg)
       boundary = T2Seg{k};
       plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3)
    end
    legend('ADC Prostate', 'DWI Prostate', 'T2 Prostate');

end
%% 
p = 3;
seg = bwboundaries(Patient(p).DWI(2).ROI);
pseg = bwboundaries(Patient(p).DWI(2).PROI);
figure, imshow(adapthisteq(Patient(p).DWI(2).Slice));
hold on
for k = 1:length(seg)
   boundary = seg{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 3)
end
hold on
for k = 1:length(pseg)
   boundary = pseg{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3)
end
%% ADC Registration         
for patientNum=1:57
    for sliceNum=1:min(min(length(Patient(patientNum).ADC),length(Patient(patientNum).DWI)),length(Patient(patientNum).T2))
        disp([int2str(patientNum),' ',int2str(sliceNum)])
        [Patient(patientNum).PRegistration.ADC(sliceNum).Slice, Patient(patientNum).PRegistration.ADC(sliceNum).ROI, Patient(patientNum).PRegistration.ADC(sliceNum).PROI] = ADCRegister(patientNum,sliceNum,Patient);
    end
end

%%  DWI Registration        
for patientNum=1:57
    for sliceNum=1:min(min(length(Patient(patientNum).ADC),length(Patient(patientNum).DWI)),length(Patient(patientNum).T2))
        disp([int2str(patientNum),' ',int2str(sliceNum)])
        [Patient(patientNum).PRegistration.DWI(sliceNum).Slice, Patient(patientNum).PRegistration.DWI(sliceNum).ROI, Patient(patientNum).PRegistration.DWI(sliceNum).PROI] = DWIRegister(patientNum,sliceNum,Patient);
    end
end

%% Registered Lesions
for patientNum = 53:53
    sliceNum = 1;

    seg1 = bwboundaries(imresize(Patient(patientNum).T2(sliceNum).ROI,1/2));
    seg2 = bwboundaries(Patient(patientNum).PRegistration.ADC(sliceNum).ROI);
    seg3 = bwboundaries(Patient(patientNum).PRegistration.DWI(sliceNum).ROI);

    figure, imshow(imresize(adapthisteq(Patient(patientNum).T2(sliceNum).Slice),1/2))
    hold on
    for k = 1:length(seg1)
       boundary = seg1{k};
       plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
    end
    for k = 1:length(seg2)
       boundary = seg2{k};
       plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
    end
    for k = 1:length(seg3)
       boundary = seg3{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
    legend('T2 ROI', 'ADC ROI', 'DWI ROI');

    seg4 = bwboundaries(Patient(patientNum).T2(sliceNum).CombinedPROI);
    for k = 1:length(seg3)
       boundary = seg3{k};
       plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
end


%% Registered Images

patientNum = 3;
sliceNum = 1;

% figure, imshowpair(imresize(adapthisteq(Patient(patientNum).T2(sliceNum).Slice),1/2),adapthisteq(Patient(patientNum).PRegistration.DWI(sliceNum).Slice),'ColorChannels',[2 1 0]);
% hold on, title('T2 & DWI')
% figure, imshowpair(imresize(adapthisteq(Patient(patientNum).T2(sliceNum).Slice),1/2),adapthisteq(Patient(patientNum).PRegistration.ADC(sliceNum).Slice),'ColorChannels',[2 1 0]);
% hold on, title('T2 & ADC')

seg = bwboundaries(Patient(patientNum).T2(sliceNum).CombinedPROI);
figure, imshow(imresize(adapthisteq(Patient(patientNum).T2(sliceNum).Slice),1/2));
hold on,
for k = 1:length(seg)
   boundary = seg{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end

seg = bwboundaries(Patient(patientNum).PRegistration.DWI(sliceNum).PROI);
figure, imshow((Patient(patientNum).PRegistration.DWI(sliceNum).Slice));
hold on,
for k = 1:length(seg)
   boundary = seg{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end

seg = bwboundaries(Patient(patientNum).PRegistration.ADC(sliceNum).PROI);
figure, imshow((Patient(patientNum).PRegistration.ADC(sliceNum).Slice));
hold on,
for k = 1:length(seg)
   boundary = seg{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
%% 

for c=1:7
    ADCSeg = bwboundaries(Patient(24).Registration(1).ADC(c).ROI);
    DWISeg = bwboundaries(Patient(24).Registration(1).DWI(c).ROI);
    T2Seg = bwboundaries(imresize(Patient(24).T2(c).ROI,1/2));

    figure,
    imshow(adapthisteq(imresize(Patient(24).T2(c).Slice, 1/2)));
    title('Shaped Based Registration (OPOE + MMI)')
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
    legend('ADC ROI', 'DWI ROI', 'T2 ROI');
end

%% 

fid=fopen('FeatureNames.csv','wt');
[rows,cols]=size(varyingFeatures)
for i=1:rows
      fprintf(fid,'%s,',varyingFeatures{i,1:end-1})
      fprintf(fid,'%s\n',varyingFeatures{i,end})
end
fclose(fid);

%% 
x = [1 2 3 4 5];
y1 = [.2 .4 .6 .4 .2];
b1 = bar(x,y1, 'b');

hold on 
y2 = [.1 .3 .5 .3 .1];
b2 = bar(x,y2, 'r');

y3 = [.1 .4 .2 .2 .1];
b3 = bar(x,y2, 'g');

y4 = [.2 .4 .6 .4 .2];
s = scatter(x,y4,'filled');
hold off

legend([b2 b3],'Low Gleason', 'High Gleason')

%% 
for i=6:6
    for ii=2:2
        figure, imshow(adapthisteq(imresize(Patient(i).PRegistration.DWI(ii).Slice,1)))
        seg = bwboundaries(Patient(i).PRegistration.DWI(ii).ROI);
        hold on
        for k = 1:length(seg)
           boundary = seg{k};
           plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
        end
    end
end