%% PCA
numFeatures = 35;

[V,U] = pca(FeaturesNormalized(1:44,:));

ReducedFeatures = U*V(1:numFeatures, :)';
