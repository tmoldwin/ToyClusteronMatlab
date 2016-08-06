clear all;
close all;
load('ex4data1.mat')
I = reshape(X(600,:),20,20)
BW1 = I
imshow(BW1);
neg = imcomplement(BW1);
figure, imshow(neg);
BW1 = edge(I,'sobel');
BW2 = edge(I,'canny');
BW3 = edge(I,'roberts');
BW4 = edge(I,'prewitt');
BW5 = edge(I,'zerocross');
BW6 = edge(I,'log');
figure, imshow(BW1)
figure, imshow(BW2), title('sobel')
figure, imshow(BW3), title('canny')
figure, imshow(BW4)
figure, imshow(BW5)
figure, imshow(BW6)