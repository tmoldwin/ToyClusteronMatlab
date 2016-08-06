% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
xTrain = loadMNISTImages('train-images.idx3-ubyte')';
yTrain = loadMNISTLabels('train-labels.idx1-ubyte')';
xTest = loadMNISTImages('t10k-images.idx3-ubyte')';
yTest = loadMNISTLabels('t10k-labels.idx1-ubyte')';
width = 28 
figure
imshow(reshape(xTrain(8,:),width,width));
yTrain(1)
figure
imshow(reshape(xTest(8,:),width,width));
yTest(1)
save('MNIST28', 'xTrain', 'yTrain', 'xTest', 'yTest');