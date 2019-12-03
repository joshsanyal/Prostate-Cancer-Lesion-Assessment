%% Normalize
FeaturesNormalized = [];
counter = 0;
featNum = [];
for i=1:507
    allEqual = true;
    for ii=2:44
        if (Features(1,i) ~= Features(ii,i))
            allEqual = false;
        end
    end
    
    if (~allEqual)
        featNum = [featNum,i];
        FeaturesNormalized = horzcat(FeaturesNormalized,normalize(Features(:,i)));
    end
end