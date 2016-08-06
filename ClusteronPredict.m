function y = ClusteronPredict(X,neighborMap)
P = size(X,1);
y = zeros(1,P);
for pattern = 1:P
    aVec = activationF(X(pattern,:),neighborMap);
    y(pattern) = sum(aVec);
end
end
