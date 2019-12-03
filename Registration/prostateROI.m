%% Reading Bitmaps into Patient Variable
for i = 58:77
    ID = Patient(i).id;
    hi = ls(['/Users/Josh/Documents/MATLAB/New51016-prostate/',int2str(ID),'/DWI/DWIROIimages/']);
    hi = hi(find(~isspace(hi)));
    bmpLoc = [-2, strfind(hi,'bmp')];
    numSlices = length(bmpLoc)-1;
    for ii = 1:numSlices
        Patient(i).DWI(ii).PROI = imresize(imread(['/Users/Josh/Documents/MATLAB/New51016-prostate/',int2str(ID),'/DWI/DWIROIimages/',hi(bmpLoc(ii)+3:bmpLoc(ii+1)+2)]),[256 256]);
    end
    
    hi = ls(['/Users/Josh/Documents/MATLAB/New51016-prostate/',int2str(ID),'/ADC/ADCROIimages/']);
    hi = hi(find(~isspace(hi)));
    bmpLoc = [-2, strfind(hi,'bmp')];
    numSlices = length(bmpLoc)-1;
    for ii = 1:numSlices
        Patient(i).ADC(ii).PROI = imresize(imread(['/Users/Josh/Documents/MATLAB/New51016-prostate/',int2str(ID),'/ADC/ADCROIimages/',hi(bmpLoc(ii)+3:bmpLoc(ii+1)+2)]),[256 256]);
    end
end
%% Displaying Prostate ROI
ProstateSeg = bwboundaries(Patient(76).T2(1).PROI);
 
figure,
imshow(adapthisteq(Patient(76).T2(1).Slice));
hold on
for k = 1:length(ProstateSeg)
   boundary = ProstateSeg{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end