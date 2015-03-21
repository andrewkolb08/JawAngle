%finalJawAngle.m
%Use the raw data files to compute the jaw angle in two different ways.
%The values of the col variables are taken from a sheet given by Dr. Berry.
clear all 
close all
%Subject 03 has pretty good data as examples
audiofilename = './subdata/sub003_oe.wav';
sensfilename = './subdata/sub003_oe_BPC.tsv';

%Use 'Skull_Stationary_Jaw_BPC.tsv' to get some variance measures.

%Start by getting dat audio, bruh
[sound, fs] = audioread(audiofilename);
soundTime = linspace(0,length(sound)/fs,length(sound));


%Now calculate the vector that will be used as the baseline for our
%calculations of jaw angle

baseVec = [1 0];

%Take the values from Dr. Berry's sheet to the MI and MM sensors
MMcol = 3;
MIcol = 4;

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
[maxMI, maxInd] = max(MIy);
MM = [MMx MMy];
MI = [MIx MIy];

jawVecs = MI-MM;

rowNorms = arrayfun(@(idx) norm(jawVecs(idx,:)), 1:size(jawVecs,1));
jawVecs = arrayfun(@(idx) jawVecs(idx,:)./rowNorms(idx), 1:size(jawVecs,1),'UniformOutput',0);
jawVecs = reshape(cell2mat(jawVecs)',2,size(MMx,1))';
baseVecs = repmat(baseVec./norm(baseVec),[size(jawVecs,1),1]);
eulerAngles = arrayfun(@(idx) -acosd(dot(jawVecs(idx,:),baseVecs(idx,:))),1:size(jawVecs));
eulerAngles = eulerAngles - max(eulerAngles)*ones(1,length(eulerAngles));

%Now try with quaternions
quatVecs = arrayfun(@(idx) qvqc(MIquat(idx,:),[0 0 1]),1:size(MIquat,1), 'UniformOutput',0);
qJawVecs = reshape(cell2mat(quatVecs)',3,size(MMx,1))';
qJawVecs = [qJawVecs(:,1) qJawVecs(:,2)];
quatAngles = arrayfun(@(idx) -acosd(dot(qJawVecs(idx,:),baseVecs(idx,:))),1:size(qJawVecs));
quatAngles = quatAngles- max(quatAngles)*ones(1,length(quatAngles));
%quatAngles = quatAngles- quatAngles(maxInd)*ones(1,length(quatAngles));

time = linspace(0,length(eulerAngles)*0.01,length(eulerAngles));
toPlot = 1:length(MIx);
soundToPlot = toPlot(1):toPlot(end)*(fs/100);
figure(1)
subplot(3,1,1)
plot(soundTime(soundToPlot),sound(soundToPlot))
title('Sound Produced')
subplot(3,1,2)
plot(time(toPlot), eulerAngles(toPlot));
title('Calculated Euler Angles')
%axis([0 35 -10 0]);
subplot(3,1,3)
plot(time(toPlot),quatAngles(toPlot));
title('Calculated Quaternion Angles');
%axis([0 35 -10 0]);

p = audioplayer(sound(soundToPlot),fs);
play(p);
