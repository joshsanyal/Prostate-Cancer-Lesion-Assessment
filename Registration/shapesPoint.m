 
%% 
x = Patient(3).ADC(2).Slice;
y = Patient(3).T2(2).Slice;
y = adapthisteq(y);

y = imresize(y, 1/2);


figure,
imshow(x)
[a,b] = getpts;
matchedPoints1 = [];
matchedPoints1(:,1) = a;
matchedPoints1(:,2) = b;

figure,
imshow(y)
[a,b] = getpts;
matchedPoints2 = [];
matchedPoints2(:,1) = a;
matchedPoints2(:,2) = b;


%% 

tformSimilarity = fitgeotrans(matchedPoints1,matchedPoints2,'affine'); 
points = size(matchedPoints1);
points = points(1);

figure,
imshowpair(x, y),
for i=1:points
    hold on, plot(matchedPoints1(i),matchedPoints1(i),'b*')
end
for i=1:points
    hold on, plot(matchedPoints2(i),matchedPoints2(i),'r*')
end


movingRegisteredRigid = imwarp(x,tformSimilarity,'OutputView',imref2d(size(y)));
 
 figure,
 imshowpair(movingRegisteredRigid, y)
 title('Registered')
 for i=1:points
        hold on, plot(matchedPoints2(i),matchedPoints2(i),'r*')
 end
for i=1:points
    [a, b] = transformPointsForward(tformSimilarity,matchedPoints1(i),matchedPoints1(i));
    hold on, plot(a,b,'b*')
end