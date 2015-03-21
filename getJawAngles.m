function [quatAngles, posAngles] = getJawAngles(sensfilename,MMcol,MIcol)
% Calculates the jaw angles using both position-based and orientation-based method.
% sensfilename: the file containing the kinematic data.
% MMcol:  the sensor  number in the file for the molar sensors
% MIcol:  the sensor number in the file of the midsagittal inc
%%

%Now calculate the vector that will be used as the baseline for our
%calculations of jaw angle

baseVec = [1 0];

%Correct the values
MMcol = MMcol-2;
MIcol = MIcol-2;

%Get the data needed to calculate the angle by each method
[subData,header] = loadtsv(sensfilename);
MMx = subData(:,3+MMcol*9+3);
MMy = subData(:,3+MMcol*9+4);
MIx = subData(:,3+MIcol*9+3);
MIy = subData(:,3+MIcol*9+4);
MIquat = subData(:,(3+MIcol*9+6):(3+MIcol*9+9));
%Rearrange the quaternions for use with the toolbox we have
MIquat = [MIquat(:,2), MIquat(:,3), MIquat(:,4), MIquat(:,1)];


%Start by calculating using the classic 2-sensor method
MM = [MMx MMy];
MI = [MIx MIy];

jawVecs = MI-MM;

rowNorms = arrayfun(@(idx) norm(jawVecs(idx,:)), 1:size(jawVecs,1));
jawVecs = arrayfun(@(idx) jawVecs(idx,:)./rowNorms(idx), 1:size(jawVecs,1),'UniformOutput',0);
jawVecs = reshape(cell2mat(jawVecs)',2,size(MMx,1))';
baseVecs = repmat(baseVec./norm(baseVec),[size(jawVecs,1),1]);
posAngles = arrayfun(@(idx) -abs(acosd(dot(jawVecs(idx,:),baseVecs(idx,:)))),1:size(jawVecs));
posAngles = posAngles - max(posAngles)*ones(1,length(posAngles));

%Now try with quaternions
quatVecs = arrayfun(@(idx) qvqc(MIquat(idx,:),[0 0 1]),1:size(MIquat,1), 'UniformOutput',0);
qJawVecs = reshape(cell2mat(quatVecs)',3,size(MMx,1))';
qJawVecs = [qJawVecs(:,1) qJawVecs(:,2)];
quatAngles = arrayfun(@(idx) -abs(acosd(dot(qJawVecs(idx,:),baseVecs(idx,:)))),1:size(qJawVecs));
quatAngles = quatAngles- max(quatAngles)*ones(1,length(quatAngles));