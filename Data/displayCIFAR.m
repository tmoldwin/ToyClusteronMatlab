load('data_batch_1.mat')
%%
sampleImage = data(90,:);
sampleImage = permute(reshape(sampleImage,32,32,3),[2 1 3])
imshow(sampleImage)
%sampleImage = reshape