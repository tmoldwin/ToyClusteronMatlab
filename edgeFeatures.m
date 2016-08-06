function features = edgeFeatures(X, width, filterName)
features = zeros(size(X));
for k = 1:size(X, 1)
    img = reshape(X(k,:), width, width);
    transform = edge(img, filterName);
    features(k,:) = reshape(transform, 1,width^2);
end
%features = features - mean(mean(features));
end

