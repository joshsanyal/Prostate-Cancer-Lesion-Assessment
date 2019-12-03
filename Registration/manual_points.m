%load("Patient_57.mat")


%% 

x = Patient(3).ADC(2).Slice;
y = Patient(3).T2(2).Slice;

imgSizeY = size(y);
imgSizeX = size(x);

fixed = mat2gray(y);
moving = mat2gray(x);

fixed = imresize(fixed, imgSizeX(1)/imgSizeY(1));


figure
imshow(moving)
title('Select Points')

[xMoving,yMoving] = getpts;

figure
imshow(fixed)
title('Select Points')

[xFixed,yFixed] = getpts;

fixedPoints = [];
movingPoints = [];

figure,
imshowpair(fixed, moving),
for i=1:size(xFixed)
    hold on, plot(xFixed(i),yFixed(i),'r*')
    fixedPoints = [fixedPoints; xFixed(i) yFixed(i)];
end
for i=1:size(xMoving)
    hold on, plot(xMoving(i),yMoving(i),'b*')
    movingPoints = [movingPoints; xMoving(i) yMoving(i)];
end
 
tformSimilarity = fitgeotrans(movingPoints,fixedPoints,'projective');
 
 movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',imref2d(size(fixed)));
 
 figure,
 imshowpair(movingRegisteredRigid, fixed)
 title('Registered')
 for i=1:size(xFixed)
        hold on, plot(xFixed(i),yFixed(i),'r*')
 end
for i=1:size(xMoving)
    [a, b] = transformPointsForward(tformSimilarity,xMoving(i),yMoving(i));
    hold on, plot(a,b,'b*')
end