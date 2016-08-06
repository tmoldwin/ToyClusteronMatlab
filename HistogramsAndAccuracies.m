function [muNeg,sigmaNeg, muPos, sigmaPos] = HistogramsAndAccuracies(x,y, predictions, posVal, negVal, threshold)
binSize = 250;
indsPos = find(y == posVal);
indsNeg = find(ismember(y, negVal));
hits = length(find(predictions(indsPos) > threshold));
hitPercent = hits / length(indsPos);
CRs = length(find(predictions(indsNeg) < threshold));
CRPercent = CRs / length(indsNeg);
%accuracy = (hits + CRs) ./ (length(indsPos)+length(indsNeg));
accuracy = (hits + CRs) ./ (length(indsPos)+length(indsNeg));
posPredict = predictions(indsPos);
negPredict = predictions(indsNeg);
muNeg = mean(negPredict);
sigmaNeg = std(negPredict);
muPos = mean(posPredict);
sigmaPos = std(posPredict);
[nPos, xoutPos] = histnorm(posPredict, binSize);
[nNeg, xoutNeg] = histnorm(negPredict, binSize);
plot(xoutPos, nPos, 'r', xoutNeg, nNeg, 'g');
hold on;
ylm=get(gca,'ylim');
plot([threshold threshold],ylm);
legend('+', '-');
if length(negVal) > 1
    negString = 'All';
else
    negString = num2str(negVal);
end
title({[num2str(posVal), ' vs. ', negString]; [' Hits: ', num2str(round(hitPercent*100)), '%', ' CR: ',  num2str(round(CRPercent*100)), '%', ' Accuracy: ', num2str(round(accuracy*100)), '%']})
xlabel('Output')
ylabel('Probability')
end

