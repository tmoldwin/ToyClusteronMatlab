load('data_batch_1.mat')
X = zeros(size(data,1), 32*32);
y = labels;
for k = 1:length(labels)
    row = data(k,:);
    RGB = reshape(row,32,32,3);
    BW = rgb2gray(RGB)';
    if(k == 50)
        imshow(BW);
    end
    X(k,:) = reshape(BW,1,32*32);
end
save('cifarBW.mat','X','y')