
%%
close all;
%load('cifarBW.mat');
load('ex4data1.mat');

%X = fourierFeatures(X,20);
%X = edgeFeatures(X,20, 'log');



posVal = 3;
negVal = 7;
X = X - repmat(mean(X,2),1,size(X,2));
inds = find(y == posVal | y == negVal);
y = y(inds);
X = X(inds,:);
N = size(y);
newInds = randperm(N);
X = X(newInds,:);
y = y(newInds);

% indsP = find(y == posVal);
% indsN = find(y == negVal);
% positivesX = X(indsP,:);
% negativesX = X(indsN,:);
% X = [positivesX; negativesX];
% positivesY = y(indsP);
% negativesY = y(indsN);
% y = [positivesY; negativesY];
% N = size(X,1);
% newInds = randperm(N);
% X = X(newInds,:);
% y = y(newInds,:);

%trainProportion = 0.75
% xTrain = X(1:round(trainProportion * N),:);
% yTrain = y(1:round(trainProportion * N));
% xTestFull = X(round(trainProportion * N)+1:end,:);
% yTestFull = y(round(trainProportion * N)+1:end);

N = size(X,1);
P = size(X,2);

figure(1)
displayData(X(randperm(size(X,1),36),:));
width = 20;


%%  Clusteron2
close all;
numSynapses = round(size(X,2)*1);
radius = 5;
numEpochs = 20;
%trainPredict = ClusteronPredict(xTrain, w, ordering, radius)
[w,mappedW, threshold] = Clusteron2Learn(numEpochs, X, y, posVal, radius, numSynapses);

%%
numCategories = 2
means = zeros(1,numCategories);
stds = zeros(1,numCategories);
SNR = zeros(1,numCategories);
w = ones(numSynapses, 1);
inds1 = find(y==posVal)
trainPredict = ClusteronPredict(X(inds1,:), w, mappedW, radius, numSynapses, 0);
inds2 = find(y == negVal);
xTest = X(inds2,:);
figure(2);
testPredict = ClusteronPredict(xTest, w, mappedW, radius, numSynapses, 0);
means(1) = mean(trainPredict);
stds(1) = std(trainPredict);
means(2) = mean(testPredict);
stds(2) = std(testPredict);
[n1, xout1] = hist(trainPredict,30);
[n2, xout2] = hist(testPredict,30);
bar(xout1, n1, 'r'); % Plot in red
hold on;
bar(xout2, n2, 'g'); % Plot in green
%%
figure(4)
subplot(1,2,1)
hold on
bar(1:2, means);
errorbar(means,stds,'.');
title('Average Firing Rate')
SNR = (means(1) - means)./(0.5*(stds(1)+stds))
subplot(1,2,2)
bar(1:2, SNR)
title('SNR')
