function neighborMap = ClusteronLearn(numEpochs, xTrain, radius, numSynapses)
%CLUSTERONLEARN Implementation of the Clusteron learning algorithm
%   The clusteron learning algorithm aims to find correlations within the
%   structure of input and map correlated features to nearby synapses. In this model, nearby synapses coactivate each other, meaning that clustered, correlated input will lead to higher responses. 
N = size(xTrain,2);
P = size(xTrain,1);

activationDisplay = zeros(2,numSynapses);

mappedW = randperm(numSynapses, N); %mappedW(i) returns the synaptic location of pixel i in the image
activeSynapses = nan*ones(1,numEpochs);
thresholds = nan*ones(1,numEpochs);
threshold = nan;
for epoch = 1:numEpochs
    meanActivations = zeros(N,1);
    neighborMap = generateNeighborMap(mappedW, radius, numSynapses);
    for pattern = 1:P
        aVec = activationF(xTrain(pattern,:), neighborMap);
        %aVec = activationF(mappedW,w,xTrain(pattern,:),radius, numSynapses);
        meanActivations = meanActivations + aVec;
    end
    meanActivations = meanActivations./P; %%mean activation of each feature;  
    if epoch == 1
        activationDisplay(1,:) = meanActivations;
        [nOrig, xOrig] =  hist(meanActivations, sqrt(length(meanActivations))*3);
    else 
        activeSynapses(epoch) = length(find(meanActivations > threshold));
    end
    
    threshold = sum(meanActivations)./N;
    thresholds(epoch) = threshold;
 %   [selfAverages, neighborAverages] = findExpectedValues(xTrain, neighborMap);
 %   subThresholdSynapses = find(meanActivations' - (selfAverages.*neighborAverages) < threshold);
    subThresholdSynapses = find(meanActivations < threshold);
    openSpines = union(setdiff(1:numSynapses,mappedW), mappedW(subThresholdSynapses)); %indices of the available spines
    mappedW(subThresholdSynapses) = openSpines(randperm(length(openSpines),length(subThresholdSynapses)));
    
    %The plot
    f2 = figure(2)
    h1 = subplot(2,2,1);
    ax1=get(h1,'position');
    set(h1,'position',ax1);
    activationDisplay(2,mappedW) = meanActivations;
    imagesc(activationDisplay)
    set(gca,'YTick',[1 2])
    set(gca,'YTickLabel',{'Original', 'Current'})
    %imagesc(activationDisplay, 'Ydir','normal', 'YTick', [1 2], 'YTickLabel', {'Original', 'Current'});
    title('Synaptic activation');
    xlabel('Synapse #')
    colorbar;
    drawnow;
    subplot(2,2,2)
    [n,x] = hist(meanActivations, sqrt(length(meanActivations))*3);
    plot(xOrig, nOrig, 'b', x,n, 'r', 'LineWidth', 2)
    legend('Original', 'Current')
    title('Histogram of activations')
    xlabel('Activation level')
    ylabel('Number of synapses')
    subplot(2,2,3)
    plot(1:numEpochs, activeSynapses);
    title('Number of synapses above threshold');
    xlabel('Epoch')
    ylabel('Number of synapses')
    drawnow;
    subplot(2,2,4)
    plot(1:numEpochs, thresholds);title('Threshold');
    drawnow;
    xlabel('Epoch')
    ylabel('Threshold')
end
saveFigure(f2, 'Training.jpg')
end

function [selfAverages, neighborAverages] = findExpectedValues(X, neighborMap)
    selfAverages = mean(X, 1);
    neighborAverages = zeros(1,size(X,2));
    for i = 1:size(X,1)
        neighborsValues = X(:, neighborMap{i});
        neighborAverages(i) = mean(sum(neighborsValues,2),1);
    end
end
    
