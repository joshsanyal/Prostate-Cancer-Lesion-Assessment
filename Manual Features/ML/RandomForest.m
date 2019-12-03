%% Random Forest
%b = randperm(54);
% scores = [];
% 
% for i = 1:6
%     xTestCV = ReducedFeatures(b(1 + 5*(i-1): min(54,5*i)),:);
%     yTestCV = Gleason(b(1 + 5*(i-1): min(54,5*i)),:);
%     xTrainCV = ReducedFeatures([b(1:5*(i-1)),b(min(54,5*i)+1:54)],:);
%     yTrainCV = Gleason([b(1:5*(i-1)),b(min(54,5*i)+1:54)],:);
%     
%     SVMModel = TreeBagger(25,xTrainCV,yTrainCV,'Method','Regression');
%     
%     [label, ~] = predict(SVMModel,xTestCV);
%     scores = [scores; label];
% end
% 
% for i = 1:4
%     xTestCV = ReducedFeatures(b(31 + 6*(i-1): min(54,30 + 6*i)),:);
%     yTestCV = Gleason(b(31 + 6*(i-1): min(54,30 + 6*i)),:);
%     xTrainCV = ReducedFeatures([b(1:30 + 6*(i-1)),b(min(54,30 + 6*i)+1:54)],:);
%     yTrainCV = Gleason([b(1:30 + 6*(i-1)),b(min(54,30 + 6*i)+1:54)],:);
%     
%     SVMModel = TreeBagger(25,xTrainCV,yTrainCV,'Method','Regression');
%     
%     [label, ~] = predict(SVMModel,xTestCV);
%     scores = [scores; label];
% end
% 
% [X,Y,T,AUC] = perfcurve(Gleason(b),scores,1);
% 
% AUC