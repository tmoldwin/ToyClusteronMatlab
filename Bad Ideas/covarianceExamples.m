

P = 1000;
N = 100;
mu1 = ones(1,N);
a1 = rand(N,N);
sigma1 = a1' * a1;
xTrain = mvnrnd(mu1,sigma1,P);
mu2 = rand(1,N);
a2 = rand(N,N);
sigma2 = a2'*a2*sigma1;
xTest = mvnrnd(mu2,sigma2,P);