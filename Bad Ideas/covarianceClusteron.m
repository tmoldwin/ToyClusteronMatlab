% P = 1000;
% N = 100;
% mu1 = ones(1,N);
% a1 = rand(N,N);
% sigma1 = a1' * a1;
% xTrain = mvnrnd(mu1,sigma1,P);
% mu2 = rand(1,N);
% a2 = rand(N,N);
% sigma2 = a2'*a2*sigma1;
% xTest = mvnrnd(mu2,sigma2,P);
%%
close all;
load('ex4data1.mat')
inds1 = find(y == 6);
inds2 = find(y == 3);
% figure(1)
% displayData(X(inds2,:));
% figure(2);
% displayData(X(inds1,:));
width = 20;
xTrain = X(inds1,:);
xTest = X(inds2,:);

xTrain = xTrain - mean(mean(xTrain));
xTest = xTest - mean(mean(xTest));

%%
% N = 300
% P = 5000
% mu = zeros(P,N);
% A = randn(N);
% [U,ignore] = eig((A+A'));
% sigma1 = U*diag(abs(randn(N,1)))*U';
% xTrain = mvnrnd(mu,sigma1, P);
% A2 = randn(N);
% [U2,ignore2] = eig((A2+A2'));
% sigma2 = U2*diag(abs(randn(N,1)))*U2';
% xTest = mvnrnd(mu,sigma2, P);
% 
% figure;
% subplot(2,1,1)
% imagesc(cov(xTrain) - sigma1)
% colorbar
% subplot(2,1,2)
% imagesc(cov(xTrain) - cov(xTest))
% colorbar


%%
N = size(xTrain,2);
numSynapses = 2 * N;
numEpochs = 20;
radius = 5;
dendriteLength = 20;
boundaries = [1 round(dendriteLength * (1:(numSynapses/dendriteLength))) numSynapses];
[mappedW,w] = myGA(numEpochs, xTrain, numSynapses, radius, boundaries);
%%
Ptrain = size(xTrain,2);
Ptest = size(xTest,2);
w = ones(numSynapses,1);
trainPredict = ClusteronPredict(xTrain, w, mappedW, radius, 0);
sum(trainPredict)./Ptrain
testPredict = ClusteronPredict(xTest, w, mappedW, radius, 0);
sum(testPredict)./Ptest

figure;
[n1, xout1] = hist(trainPredict,30);
[n2, xout2] = hist(testPredict,30);
bar(xout1, n1, 'r'); % Plot in red
hold on;
bar(xout2, n2, 'g'); % Plot in green