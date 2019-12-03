A = abs(corrcoef(ReducedFeatures));
figure
colormap('parula')
imagesc(A)
colorbar
% xticks(1:613)
% xticklabels(varyingFeatures)
% yticks(1:613)
% yticklabels(varyingFeatures)
% 
