%% CV

numPatients = 41;
b = b6;
NormalizedEN2AUC = [];
NormalizedEN2Std = [];
X = [];
Y = [];

folds = 5;

for a = 6:8
    alpha = a/20; 

    scores = [];
    auc = [];

    step = ceil(numPatients/folds);

    for i = 1:mod(numPatients,folds)
        xTestCV = FeaturesNormalized(b(1 + step*(i-1):step*i),:);
        yTestCV = Gleason(b(1 + step*(i-1):step*i));
        
        xTrainCV = FeaturesNormalized([b(1:step*(i-1)),b(step*i+1:numPatients)],:);
        yTrainCV = Gleason([b(1:step*(i-1)),b(step*i+1:numPatients)]);
        
        disp([int2str(a),' ',int2str(i)])

        [B,FitInfo] = lasso(xTrainCV,yTrainCV,'Alpha', alpha, 'CV',10,'Lambda',linspace(0,0.004),'RelTol',0.00001);
        idxLambda1SE = FitInfo.Index1SE;
        coef = B(:,idxLambda1SE);
        coef0 = FitInfo.Intercept(idxLambda1SE);

        score = xTestCV*coef + coef0;

        [X2,Y2,T2,AUC2] = perfcurve(yTestCV,score,1);
        if AUC2 < 0.5
            AUC2 = 1 - AUC2;
            X{1,i} = Y2;
            Y{1,i} = X2;
        else
            X{1,i} = X2;
            Y{1,i} = Y2;
        end
        auc = [auc, AUC2];

    end

    start = mod(numPatients,folds)*ceil(numPatients/folds);
    step = floor(numPatients/folds);

    for i = 1:folds-mod(numPatients,folds)
        xTestCV = FeaturesNormalized(b(start + 1 + step*(i-1): start + step*i),:);
        yTestCV = Gleason(b(start + 1 + step*(i-1): start + step*i));
        xTrainCV = FeaturesNormalized([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)],:);
        yTrainCV = Gleason([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)]);

        disp([int2str(a),' ',int2str(i+4)])

        [B,FitInfo] = lasso(xTrainCV,yTrainCV,'Alpha',alpha, 'CV',10,'Lambda',linspace(0,0.004),'RelTol',0.00001);
        idxLambda1SE = FitInfo.Index1SE;
        coef = B(:,idxLambda1SE);
        coef0 = FitInfo.Intercept(idxLambda1SE);
        
        score = xTestCV*coef + coef0;

        [X2,Y2,T2,AUC2] = perfcurve(yTestCV,score,1);
        if AUC2 < 0.5
            AUC2 = 1 - AUC2;
            X{1,i+4} = Y2;
            Y{1,i+4} = X2;
        else
            X{1,i+4} = X2;
            Y{1,i+4} = Y2;
        end
        auc = [auc, AUC2];

    end

    NormalizedEN2AUC(a) = mean(auc)
    NormalizedEN2Std(a) = std(auc)

end