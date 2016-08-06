function [mappedW, w] = myGA(numEpochs, xTrain, numSynapses, radius, boundaries)
covMat = cov(xTrain);
N = size(xTrain,2);
maxPop = 1000;
maxCrosses = 50;
maxMutations = 50;
keepProportion = 0.2;
fitnesses = nan*ones(1,numEpochs);
activations = nan*ones(1,numEpochs);
pop = initPopulation(maxPop, numSynapses, N);
figure;
for epoch = 1:numEpochs
    epoch
    fitnessVector = zeros(1,size(pop,1));
    for ii = 1:length(fitnessVector)
        fitnessVector(ii) = fitnessFunction(pop(ii,:), xTrain, covMat, radius, boundaries);
        %fitnessVector(ii) = fitnessFunction2(xTrain, w, pop(ii,:), radius);
    end
    fitnesses(epoch) = mean(fitnessVector);
    topPop = rankAndKill(pop, fitnessVector, keepProportion);
    mappedW = topPop(1,:); %This is the best of the best
    activations(epoch) = sum(ClusteronPredict(xTrain, ones(numSynapses,1), mappedW, radius, 0));
    
    %Plot
    h1 = subplot(3,1,1);
    ax1=get(h1,'position');
    set(h1,'position',ax1);
    %w = calculateWeights(mappedW, xTrain, numSynapses); 
    w = calculateWeights2(mappedW, xTrain, numSynapses, radius);
    imagesc(w'); 
    colorbar;
    title('Weights')
    drawnow;
   
    subplot(3,1,2)
    plot(1:numEpochs, fitnesses); 
    title('Fitness')
    drawnow;


    subplot(3,1,3)
    plot(1:numEpochs, activations);
    title('Activation');
    drawnow;
    
    pop = breedStep(topPop, maxCrosses, maxMutations, numSynapses, maxPop);
end
end

function newPop = breedStep(pop, maxCrosses, maxMutations, numSynapses, maxPop)
newPop = zeros(maxPop,size(pop,2));
for n = 1:maxPop
    m1 = pop(ceil(size(pop,1)*rand),:);
    m2 = pop(ceil(size(pop,1)*rand),:);
    mNew = crossOver(maxCrosses, m1, m2);
    mNew = mutate(maxMutations, mNew, numSynapses);
    newPop(n,:) = mNew;
end
end

function pop = initPopulation(maxPop, numSynapses, N)
pop = zeros(maxPop,N);
for ii = 1:maxPop
    pop(ii,:) = randperm(numSynapses, N);
end
end

function mNew = crossOver(maxCrosses, m1, m2)
numCrosses = round(maxCrosses*(rand));
setDif = setdiff(m1,m2);
crossOverIndices = randperm(length(setDif), min(numCrosses, length(setDif)));
mNew = m1;
mNew(crossOverIndices) = setDif(crossOverIndices);
end

function mNew = mutate(maxMutations, m1, numSynapses)
numMutations = round(maxMutations*(rand));
setDif = setdiff(1:numSynapses, m1);
mutationIndices = randperm(length(m1), min(length(setDif),numMutations));
mNew = m1;
mNew(mutationIndices) = setDif(randperm(length(setDif), min(length(setDif),numMutations)));
end

function newPop = rankAndKill(population, fitnessVector, keepProportion)
newPop = sortrows([-fitnessVector' population],1);
newPop = newPop(1:round(size(population,1) * keepProportion), 2:end);
end

function fit = fitnessFunction(member, xTrain, covMat, radius, boundaries)
avg = mean(xTrain);
fit = 0;
for ii = 1:length(member)
    activation = 0;
    neighbors = findNeighbors(member, ii, radius, boundaries); %The indices in N containing neighboring synapses
    for j = 1:length(neighbors)
        activation = activation + avg(j) * covMat(ii,j);
    end
    fit = fit + avg(ii) * activation;
end
end

function w = calculateWeights2(member, xTrain, numSynapses, radius)
covMat = cov(xTrain);
w = 0e-6*ones(numSynapses,1);
for ii = 1:length(member)
    loc = member(ii);
    neighbors = find(abs(member - loc) < radius); %The indices in N containing neighboring synapses
    for j = 1:length(neighbors)
        w(loc) = w(loc) + covMat(ii,j);
    end
end
end

function w = calculateWeights(member, xTrain, numSynapses)
w = ones(numSynapses,1);
averageActivation = mean(xTrain);
w(member) = averageActivation;
end

function fit = fitnessFunction2(xTrain, w, member, radius)
fit = mean(ClusteronPredict(xTrain, w, member, radius,0));
end

function neighbors = findNeighbors(member, index, radius, boundaries)
loc = member(index);
% boundaryA = max(loc - radius, max(boundaries(find(boundaries - loc <= 0))));
% boundaryB = min(loc + radius, min(boundaries(find(boundaries - loc >= 0))));
% neighbors = find((member > boundaryA) & (member < boundaryB));

% k = 20;
% dist = member - loc;
% neighbors = find((dist > 0 & dist < radius & ceil(dist/k) == ceil(loc/k))|(-dist > 0 & -dist < radius & floor(-dist/k) == floor(loc/k)));

neighbors = find(abs(member - loc) < radius);
end

function dup = dupes(member)
dup = 1;
length(member)
length(unique(member))
if length(member) == length(unique(member))
    dup =  0;
end
end
