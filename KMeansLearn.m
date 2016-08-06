function neighborMap = KMeansLearn( xTrain, numClusters)
mappedWeights = zeros(1, size(xTrain,2));
covMat = cov(xTrain);
figure;
subplot(1,2,1)
imagesc(covMat)
idx = kmeans(covMat, numClusters, 'EmptyAction', 'singleton');
synapseIndex = 1;
neighborMap = {{}}
for ii = 1:numClusters
    cluster = find(idx == ii);
    length(cluster)
    neighborMap(cluster) = {cluster};
    mappedWeights(synapseIndex:synapseIndex + length(cluster) - 1) = cluster;
    synapseIndex = synapseIndex + length(cluster);
end
subplot(1,2,2)
imagesc(covMat(mappedWeights,:))
%neighborMap = generateNeighborMap(mappedWeights, radius, numSynapses);
