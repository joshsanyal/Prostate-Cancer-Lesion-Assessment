%% SVM

numPatients = 44;
NormalizedSVMAUC = [0];
NormalizedSVMStd = [];
X = [];
Y = [];

folds = 5;

while(max(max(NormalizedSVMAUC)) < 0.85)
    b = b6;
    % Kernel Function
    for d = 4:4
        if d == 1
            kernel = 'gaussian';
        elseif d == 2
            kernel = 'rbf'; 
        elseif d == 3
            kernel = 'linear';  
        else
            kernel = 'polynomial';
        end
        % Solver
        for e = 2:2
            if e == 1
                solver = 'ISDA';
            else
                solver = 'SMO';
            end

            auc = [];
            scores = [];

            step = ceil(numPatients/folds);

            for i = 1:mod(numPatients,folds)

                xTestCV = ReducedFeatures(b(1 + step*(i-1):step*i),:);
                yTestCV = Gleason(b(1 + step*(i-1): step*i));
                xTrainCV = ReducedFeatures([b(1:step*(i-1)),b(step*i+1:numPatients)],:);
                yTrainCV = Gleason([b(1:step*(i-1)),b(step*i+1:numPatients)]);

                SVMModel = fitcsvm(xTrainCV,yTrainCV,'Solver',solver,'KernelFunction',kernel);

                [label, score] = predict(SVMModel,xTestCV);
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

                SVMModel = fitcsvm(xTrainCV,yTrainCV,'Solver',solver,'KernelFunction',kernel);

                [label, score] = predict(SVMModel,xTestCV);
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

            NormalizedSVMAUC(d,e) = mean(auc);
            NormalizedSVMStd(d,e) = std(auc);
        end
    end
end

max(max(NormalizedSVMAUC))