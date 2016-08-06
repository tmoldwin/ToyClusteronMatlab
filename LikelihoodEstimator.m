function likelihoods = LikelihoodEstimator(xTest, xTrain)
N = size(xTrain,1);
P = size(xTrain,2);
%noise = 1e0 * rand(N,P);
%xTrain = xTrain + noise;
displayData(xTrain(1:36,:));
covMat = cov(xTrain);
% figure;
% imagesc(covMat);
% rnk = rank(covMat)
% determinant = det(covMat)
mu = mean(xTrain)';
testSize = size(xTest,1);
likelihoods = zeros(1,testSize);
coeff = 1./sqrt((2*pi)^P*det(covMat));
covInv = pinv(covMat);
rank(covInv);
size(mu);
for k = 1:testSize
    x = xTest(k,:).';
    size(coeff);
    %likelihoods(k) = %-0.5*((x - mu).' * covInv * (x-mu));
    likelihoods(k) = exp(-0.0005*((x - mu).' * covInv * (x-mu)));
end
end

