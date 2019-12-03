%% Ensemble

numPatients = 74;
NormalizedEnsembleAUC = [];
NormalizedEnsembleStd = [];


auc = [];

step = ceil(numPatients/10);

for i = 1:mod(numPatients,10)
    disp(i);
    xTestCV = ReducedFeatures(b(1 + step*(i-1):step*i),:);
    xTestENCV = FeaturesNormalized(b(1 + step*(i-1):step*i),:);
    yTestCV = Gleason(b(1 + ceil(numPatients/10)*(i-1): step*i),:);
    xTrainCV = ReducedFeatures([b(1:step*(i-1)),b(step*i+1:numPatients)],:);
    xTrainENCV = FeaturesNormalized([b(1:step*(i-1)),b(step*i+1:numPatients)],:);
    yTrainCV = Gleason([b(1:step*(i-1)),b(step*i+1:numPatients)],:);

    SVMModel = fitcsvm(xTrainCV,yTrainCV,'Solver','ISDA','KernelFunction','Linear');
    [label, score] = predict(SVMModel,xTestCV);
    
    LRModel = fitclinear(xTrainCV,yTrainCV, 'Learner', 'logistic','Lambda',0.00001,'Solver','SPARSA');
    [label3, score2] = predict(LRModel,xTestCV);
    
    [B,FitInfo] = lasso(xTrainENCV,yTrainCV,'Alpha', 0.05, 'CV',10,'Lambda',linspace(0,0.005),'RelTol',0.000015);
    idxLambda1SE = FitInfo.Index1SE;
    coef = B(:,idxLambda1SE);
    coef0 = FitInfo.Intercept(idxLambda1SE);
    score3 = xTestENCV*coef + coef0;
    
    [B,FitInfo] = lasso(xTrainENCV,yTrainCV,'Alpha', 0.4, 'CV',10,'Lambda',linspace(0,0.005),'RelTol',0.000015);
    idxLambda1SE = FitInfo.Index1SE;
    coef = B(:,idxLambda1SE);
    coef0 = FitInfo.Intercept(idxLambda1SE);
    score4 = xTestENCV*coef + coef0;
    
    [B,FitInfo] = lasso(xTrainENCV,yTrainCV,'Alpha', 0.95, 'CV',10,'Lambda',linspace(0,0.005),'RelTol',0.000015);
    idxLambda1SE = FitInfo.Index1SE;
    coef = B(:,idxLambda1SE);
    coef0 = FitInfo.Intercept(idxLambda1SE);
    score5 = xTestENCV*coef + coef0;
    
    scores = [];
    for ii=1:step
        scores(ii) = (score(ii,2)+score2(ii,2)+score3(ii)+score4(ii)+score5(ii))/5;
    end

    [X2,Y2,T2,AUC2] = perfcurve(yTestCV,scores,1);
    if AUC2 < 0.5
        AUC2 = 1 - AUC2;
    end
    auc = [auc, AUC2];

end

start = mod(numPatients,10)*ceil(numPatients/10);
step = floor(numPatients/10);

for i = 1:10-mod(numPatients,10)
    disp(i);
    xTestCV = ReducedFeatures(b(start + 1 + step*(i-1): start + step*i),:);
    xTestENCV = FeaturesNormalized(b(start + 1 + step*(i-1): start + step*i),:);
    yTestCV = Gleason(b(start + 1 + step*(i-1): start + step*i),:);
    xTrainCV = ReducedFeatures([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)],:);
    xTrainENCV = FeaturesNormalized([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)],:);
    yTrainCV = Gleason([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)],:);

    SVMModel = fitcsvm(xTrainCV,yTrainCV,'Solver','ISDA','KernelFunction','Linear');
    [label, score] = predict(SVMModel,xTestCV);
    
    LRModel = fitclinear(xTrainCV,yTrainCV, 'Learner', 'logistic','Lambda',0.00001,'Solver','SPARSA');
    [label3, score2] = predict(LRModel,xTestCV);
    
    [B,FitInfo] = lasso(xTrainENCV,yTrainCV,'Alpha', 0.05, 'CV',10,'Lambda',linspace(0,0.005),'RelTol',0.000015);
    idxLambda1SE = FitInfo.Index1SE;
    coef = B(:,idxLambda1SE);
    coef0 = FitInfo.Intercept(idxLambda1SE);
    score3 = xTestENCV*coef + coef0;
    
    [B,FitInfo] = lasso(xTrainENCV,yTrainCV,'Alpha', 0.4, 'CV',10,'Lambda',linspace(0,0.005),'RelTol',0.000015);
    idxLambda1SE = FitInfo.Index1SE;
    coef = B(:,idxLambda1SE);
    coef0 = FitInfo.Intercept(idxLambda1SE);
    score4 = xTestENCV*coef + coef0;
    
    [B,FitInfo] = lasso(xTrainENCV,yTrainCV,'Alpha', 0.95, 'CV',10,'Lambda',linspace(0,0.005),'RelTol',0.000015);
    idxLambda1SE = FitInfo.Index1SE;
    coef = B(:,idxLambda1SE);
    coef0 = FitInfo.Intercept(idxLambda1SE);
    score5 = xTestENCV*coef + coef0;
    
    scores = [];
    for ii=1:step
        scores(ii) = (score(ii,2)+score2(ii,2)+score3(ii)+score4(ii)+score5(ii))/5;
    end

    [X2,Y2,T2,AUC2] = perfcurve(yTestCV,scores,1);
    if AUC2 < 0.5
        AUC2 = 1 - AUC2;
    end
    auc = [auc, AUC2];

end

mean(auc)
std(auc)