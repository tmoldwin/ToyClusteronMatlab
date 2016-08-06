

function neighborMap = generateNeighborMap(mappedW, radius, numSynapses)
    neighborMap = {};
    bM = backMap(mappedW, numSynapses);
    for ii = 1:length(mappedW)
        loc = mappedW(ii);
        neighborMap{ii} = (findNeighbors(loc, radius, bM));
    end
end

function neighbors = findNeighbors(loc, radius, bM)
L = max(1, loc - radius);
U = min(loc + radius, length(bM));
slice = bM(L:U);
neighbors = slice(slice>0);
end

function bM = backMap (mappedW, numSynapses)
bM = zeros(1, numSynapses);
    for k = 1:length(mappedW)
        val = mappedW(k);
        bM(val) = k;
    end    
end
