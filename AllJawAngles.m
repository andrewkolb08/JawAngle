%AllJawAngles
%Use the raw data files to compute the jaw angle in two different ways.
%Also compute cross correlation between the two produced signals for each
%subject.
clear all 
close all
plotting = 0;

%Start by getting the data from the correct directory.
dataPattern = 'subData\*oe_BPC*.tsv';
filelist = dir(dataPattern);
fileNames = strcat('subdata\',{filelist.name}');


xcorrVals = zeros(16,3);
for i=1:16
    if((i==6)||(i==8)||(i==9)||(i==11))
        problem = 1;
    else
        problem = 0;
    end
    if(i == 13)
        [quatAngles, posAngles] = getJawAngles(fileNames{i},4,3,problem);
    else
        [quatAngles, posAngles] = getJawAngles(fileNames{i},3,4,problem);
    end
    


    posProbInds = find(isnan(posAngles));
    quatProbInds = find(isnan(quatAngles));
    while(~and(isempty(posProbInds),isempty(quatProbInds)))
        posAngles(posProbInds) = posAngles(posProbInds-ones(1,numel(posProbInds)));
        quatAngles(quatProbInds) = quatAngles(quatProbInds-ones(1,numel(quatProbInds)));
        posProbInds = find(isnan(posAngles));
        quatProbInds = find(isnan(quatAngles));
    end
    
    crossCorr = xcorr(quatAngles,posAngles,'coeff');
    [maxVal, maxInd] = max(crossCorr);
    xcorrVals(i,:) = [maxVal, maxInd, median(1:length(crossCorr))];
    
    if(plotting)

    end
end

