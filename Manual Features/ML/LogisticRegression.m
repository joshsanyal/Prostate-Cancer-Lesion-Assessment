%% ClassificationLinear

numPatients = 44;
b = randperm(44);
NormalizedLRAUC = [];
NormalizedLRStd = [];
X = [];
Y = [];

folds = 5;

% Solver
for d = 2:2
    if d == 1
        solver = 'sgd';
    elseif d == 2
        solver = 'asgd'; 
    elseif d == 3
        solver = 'bfgs';  
    elseif d == 4
        solver = 'sparsa';
    end 
    disp(int2str(d));

    auc = [];
    scores = [];
    test = [];

    step = ceil(numPatients/folds);

        for i = 1:mod(numPatients,folds)
            xTestCV = ReducedFeatures(b(1 + step*(i-1):step*i),:);
            yTestCV = Gleason(b(1 + step*(i-1): step*i));
            xTrainCV = ReducedFeatures([b(1:step*(i-1)),b(step*i+1:numPatients)],:);
            yTrainCV = Gleason([b(1:step*(i-1)),b(step*i+1:numPatients)]);

            LRModel = fitclinear(xTrainCV,yTrainCV, 'Learner', 'logistic','Lambda',0.00001,'Solver',solver);

            [label, score] = predict(LRModel,xTestCV);
            scores = [scores;score(:,2)];

            [X2,Y2,T2,AUC2] = perfcurve(yTestCV,score(:,2),1);
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
            xTestCV = ReducedFeatures(b(start + 1 + step*(i-1): start + step*i),:);
            yTestCV = Gleason(b(start + 1 + step*(i-1): start + step*i));
            xTrainCV = ReducedFeatures([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)],:);
            yTrainCV = Gleason([b(1:start + step*(i-1)),b(start + step*i+1:numPatients)]);

            LRModel = fitclinear(xTrainCV,yTrainCV, 'Learner', 'logistic','Lambda',0.00001,'Solver',solver);

            [label, score] = predict(LRModel,xTestCV);
            scores = [scores;score(:,2)];

            [X2,Y2,T2,AUC2] = perfcurve(yTestCV,score(:,2),1);
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

    NormalizedLRAUC(d) = mean(auc)
    NormalizedLRStd(d) = std(auc)
end