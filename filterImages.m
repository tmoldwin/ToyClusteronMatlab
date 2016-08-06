X = load('ex4data1.mat')
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

gArray = gaborFilterBank(5,8,39,39)
for k = 1:size(xTrain, 1)
    img = reshape(xTrain(k,:), width, width);
    transform = gaborFeatures(img, gArray,1,1);
    size(transform)
   % xTrain(k,:) = reshape(transform, 1,400);
end
for k = 1:size(xTest, 1)
    img = reshape(xTest(k,:), width, width);
    transform = gaborFeatures(img, gArray,1,1);
   % xTest(k,:) = reshape(transform, 1,400);
end

xTrain = xTrain - mean(mean(xTrain));
xTest = xTest - mean(mean(xTest));

figure(1)
displayData(xTrain(inds1,:));
figure(2);
displayData(xTest(inds2,:));