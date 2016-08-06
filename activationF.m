function aVec  = activationF(X,neighborMap)
N = size(X,2);
aVec = zeros(N,1);
for ii = 1:N
    neighbors = neighborMap{ii};
    activation = X(ii) * sum(X(neighbors));
    aVec(ii) = activation;
end

% function aVec,  = activationF(mappedW,w,x,radius, numSynapses)
% N = size(x,2);
% aVec = zeros(N,1);
% bM = backMap(mappedW, numSynapses);
% for ii = 1:N
%     loc = mappedW(ii);
%     neighbors = findNeighbors(mappedW, loc, radius);
%     %neighbors = findNeighbors2(loc, radius, bM, 50); %The indices in x containing neighboring synapses
%     neighborWeights = w(mappedW(neighbors)); %The weights of those synapses
%     activation = w(loc) * x(ii) * (x(neighbors) * neighborWeights);
%     aVec(ii) = activation;
% end
% end
% 
% function neighbors = findNeighbors(mappedW, loc, radius)
%     neighbors = find(abs(mappedW - loc) <= radius);
% end
% 
% function neighbors = findNeighbors2(loc, radius, bM, dendriteSize)
% if mod(loc,dendriteSize) > 0
%     L = floor(loc/dendriteSize) * dendriteSize + 1;
%     U = ceil(loc/dendriteSize) * dendriteSize;
% else
%     L = loc - dendriteSize;
%     U = loc;
% end
% L = max(L, loc - radius);
% U = min([U loc + radius length(bM)]);
% slice = bM(L:U);
% neighbors = slice(slice>0);
% end
% 
% function bM = backMap (mappedW, numSynapses)
% bM = zeros(1, numSynapses);
%     for k = 1:length(mappedW)
%         val = mappedW(k);
%         bM(val) = k;
%     end    
% end
