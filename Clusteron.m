
%%
normalize0 = @(X) X %No normalization
normalize1 = @(X) X - repmat(mean(X,2),1,size(X,2)); %mean normalize each image
normalize2 = @(X) X - repmat(mean(X,1),size(X,1), 1); %mean normalize each pixel (by column)
normalize3 = @(X) (X - repmat(mean(X,2),1,size(X,2)))./repmat(std(X,0,2),1,size(X,2)) %Gauss Normalize (for each pixel, subtract the mean of the image and divide by the std of the image)
normalize4 = @(X) (X - repmat(min(X,[],2),1,size(X,2)))./ (repmat(max(X,[],2),1,size(X,2)) - repmat(min(X,[],2),1,size(X,2)))%Min-Max Normalize (for each pixel, subtract the min of the pixel and divide by range (max-min) of the image

% load('ProcessedMNIST28.mat')
%load('MNIST28')
load('FilteredMNIST28')
%Plot data
displayData(xTrain(1:36,:));
title('Normalization and Edge Detection')
numTrainExamples = 10000
numTestExamples = 10000

xTrain = normalize3(xTrain(1:numTrainExamples,:));
yTrain = yTrain(1:numTrainExamples);
xTest = normalize3(xTest(1:numTestExamples,:));
yTest = yTest(1:numTestExamples);

close all;

%Choose the class label for training
posVal = 9;
inds1 = find(yTrain == posVal);
xTrainPos = normalize0(xTrain(inds1,:));
%% Normal Clusteron


%Define clusteron parameters
numSynapses = round(size(xTrainPos,2)*1);
radius = 50;
numEpochs = 20;

%Learn
neighborMap = ClusteronLearn(numEpochs, xTrainPos, radius, numSynapses);
%% K-means Clusteron
neighborMap = KMeansLearn(xTrainPos, 10);
%% Predict on training set
predictTrain = ClusteronPredict(xTrain, neighborMap);
%% Overall histogram and accuracy on training set
ytrainBinary = zeros(1,length(yTrain));
ytrainBinary(inds1) = 1;
[tpr,fpr,T] = roc(ytrainBinary, predictTrain);
[val , ind] = max(tpr + (1-fpr));
threshold = T(ind)

f3 = figure('units','normalized','outerposition',[0 0 0.5 0.5])
subplot(1,2,1)
negVal = setdiff(yTrain, posVal);
[muNeg, sigmaNeg, muPos, sigmaPos] = HistogramsAndAccuracies(xTrain, yTrain, predictTrain, posVal, negVal, threshold);

subplot(1,2,2)
plot(tpr,fpr,tpr(ind),fpr(ind),'+')
title('ROC')
xlabel('True positives')
ylabel('False positives')
saveFigure(f3, 'ROC.jpg')
%% Histograms and accuracy, for training set
close all;
numCategories = length(unique(yTrain)) - 1
f4 = figure('units','normalized','outerposition',[0 0 0.5 0.5])
meansTrain = zeros(1,numCategories);
stdsTrain = zeros(1,numCategories);
for k = 1:numCategories
    subplot(sqrt(numCategories), sqrt(numCategories), k)
    [muNeg, sigmaNeg, muPos, sigmaPos] = HistogramsAndAccuracies(xTrain, yTrain, predictTrain, posVal, k, threshold);
    meansTrain(k) = muNeg;
    stdsTrain(k) = sigmaNeg;
end
saveFigure(f4, 'TrainResults.jpg')
%% Predict on test set
predictTest = ClusteronPredict(xTest, neighborMap);
%% Combined histogram for test set
f7 = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
negVal = setdiff(yTest, posVal);
[muNeg, sigmaNeg, muPos, sigmaPos] = HistogramsAndAccuracies(xTest, yTest, predictTest, posVal, negVal, threshold);
saveFigure(f7, 'ResultsTestAll.jpg');
%% Individual histograms for test set
meansTest = zeros(1,numCategories);
stdsTest = zeros(1,numCategories);
f5 = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
for k = 1:numCategories
    subplot(sqrt(numCategories), sqrt(numCategories), k)
    [muNeg, sigmaNeg, ~, ~] = HistogramsAndAccuracies(xTest, yTest, predictTest, posVal, k, threshold);
    meansTest(k) = muNeg;
    stdsTest(k) = sigmaNeg;
end
saveFigure(f5, 'TestResults.jpg')

f6 = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
subplot(1,2,1);
bar((1:numCategories)',[meansTrain; meansTest]');
hold on;
errorbar((1:k)-0.15,meansTrain,stdsTrain,'.');
hold on;
errorbar((1:k)+0.15,meansTest,stdsTest,'.');
legend('Train', 'Test');
title('Average output');
xlabel('Category')
ylabel('Output')
SNRTrain = (meansTrain(posVal) - meansTrain)./(0.5*(stdsTrain(posVal)+stdsTrain));
SNRTest = (meansTest(posVal) - meansTest)./(0.5*(stdsTest(posVal)+stdsTest));
subplot(1,2,2);
bar((1:numCategories)', [SNRTrain; SNRTest]');
title('SNR');
xlabel('Category')
ylabel('SNR')
legend('Train', 'Test');
saveFigure(f6, 'MeansAndSNR.jpg');
%%
inds2 = find(yTest ~= posVal);
likelihoods = LikelihoodEstimator(xTest,xTrain(inds1,:));
f8 = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
scatter(predictTest(inds2),likelihoods(inds2),'b','o');
hold on;
scatter(predictTest(inds1),likelihoods(inds1),'r','+', 'LineWidth', 1)
hold on;
ylm=get(gca,'ylim');
plot([threshold threshold],ylm);
xlabel('Number of spikes');
ylabel('Likelihood prediction');
legend('-','+', 'Location', 'NorthWest')
R = corrcoef(predictTest,likelihoods);
title(['Spikes vs. likelihood for clusteron trained on ', num2str(posVal)]);
saveFigure(f8, 'LikelihoodVsClusteron.jpg');

