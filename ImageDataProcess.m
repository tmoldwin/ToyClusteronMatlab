function ImageDataProcess()
close all;
%load('cifarBW.mat');
%load('ex4data1.mat');
load('MNIST28.mat')
trainSize = 10000
testSize = 10000

xTrain = xTrain(1:trainSize, :);
yTrain = yTrain(1:trainSize);
xTest = xTest(1:testSize, :);
yTest = yTest(1:testSize);

%We're not using 0 because it's annoying to plot on a 3*3 plot.
% nonZeroTrainIndices = find(yTrain~=0);
% nonZeroTestIndices = find(yTest ~= 0);
% yTrain = yTrain(nonZeroTrainIndices);
% xTrain = xTrain(nonZeroTrainIndices,:);
% yTest = yTest(nonZeroTestIndices);
% xTest = xTest(nonZeroTestIndices,:);

width = 28;

%Plot original data
f1 = figure(1);
subplot(1,2,1);
displayData(xTrain(1:36,:));
title('Original')

%Extract edge features and normalize each image by its mean
xTrain = edgeFeatures(xTrain,width, 'log');
xTest = edgeFeatures(xTest,width, 'log');

save('FilteredMNIST28', 'xTrain', 'yTrain', 'xTest', 'yTest')

%%
load('FilteredMNIST28');
xTrain = normalizeData(xTrain);
xTest = normalizeData(xTest);
subplot(1,2,2)
displayData(xTrain(1:36,:));
title('Normalization and Edge Detection')

saveFigure(f1, 'MNIST28.jpg')

save('ProcessedMNIST28', 'xTrain', 'yTrain', 'xTest', 'yTest')
saveFigure(f1, 'MNIST28.jpg')
save('ProcessedMNIST28Norm2', 'xTrain', 'yTrain', 'xTest', 'yTest')
end

function normalizedX = normalizeData(X)
    normalizedX = X - repmat(mean(X,2),1,size(X,2)); %Normalization
end

function normalizedX = normalizeData2(X)
    normalizedX = X - repmat(mean(X,1),size(X,1), 1); %Normalization
   size(normalizedX)
end