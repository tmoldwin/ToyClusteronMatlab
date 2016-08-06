function [ covMat ] = calculateCovariance( X )
%CALCULATECOVARIANCE calculates the covariance matrix of a random variable
%based on examples
P = size(X,1);
N = size(X,2);
averages = mean(X);
covMat = zeros(N,N);
for ii = 1:P
    pattern = X(ii,:);
    pattern - averages
    covMat = covMat + ((pattern - averages).' * (pattern - averages));
    figure;
    imagesc(covMat);drawnow;
end
covMat = (1/(P-1)) * covMat;
end

