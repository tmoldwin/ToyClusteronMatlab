function [w,mappedW, threshold] = Clusteron2Learn(numEpochs, xTrain, yTrain, trainVal, radius, numSynapses)
%CLUSTERONLEARN Implementation of the Clusteron learning algorithm
%   The clusteron learning algorithm aims to find correlations within the
%   structure of input and map correlated features to nearby synapses. In this model, nearby synapses coactivate each other, meaning that clustered, correlated input will lead to higher responses. 

N = size(xTrain,2);
P = size(xTrain,1);
w = ones(numSynapses,1);
trainVal
size(yTrain == trainVal)
size(yTrain ~= trainVal)
% w = round(rand(N,1));
% w(w==0) = -1;
mappedW = randperm(numSynapses, N);
activeSynapses = nan*ones(1,numEpochs);
thresholds = nan*ones(1,numEpochs);
for epoch = 1:numEpochs
    meanActivations = zeros(N,1);
    for pattern = 1:P
        if yTrain(P) == trainVal
        aVec = activationF(mappedW,w,xTrain(pattern,:),radius, numSynapses);
        else
        aVec = -0*activationF(mappedW,w,xTrain(pattern,:),radius, numSynapses);
        end
        meanActivations = meanActivations + aVec;     
    end
    meanActivations = meanActivations./P; %%mean activation of each feature;
    threshold = sum(meanActivations)./N;
    thresholds(epoch) = threshold;
    subThresholdSynapses = find(meanActivations < threshold);
    activeSynapses(epoch) = N - size(subThresholdSynapses,1);
  %  openSpines = union(setdiff(1:numSynapses,mappedW), subThresholdSynapses);
    openSpines = union(setdiff(1:numSynapses,mappedW), mappedW(subThresholdSynapses)); %indices of the available spines
    mappedW(subThresholdSynapses) = openSpines(randperm(length(openSpines),length(subThresholdSynapses)));
    h1 = subplot(3,1,1);
    ax1=get(h1,'position');
    set(h1,'position',ax1);    
    weightDisplay = zeros(1,numSynapses);
    weightDisplay(mappedW) = meanActivations;
    imagesc(weightDisplay);
    title('Synaptic Activation');
    colorbar;
    drawnow;
    subplot(3,1,2)
    plot(1:numEpochs, activeSynapses);
    title('# Synapses above Threshold');
    drawnow;
    subplot(3,1,3)
    plot(1:numEpochs, thresholds);title('Threshold');
    drawnow;
end
end
