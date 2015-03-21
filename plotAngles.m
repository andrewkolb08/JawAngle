function [] = plotAngles(subnum,startTime,endTime)
%Plots the sound and angles in both quaternion and position data
    dataPattern = 'subData\*oe_BPC*.tsv';
    filelist = dir(dataPattern);
    fileNames = strcat('subdata\',{filelist.name}');
    
    soundPattern = 'subData\*oe*.wav';
    soundlist = dir(soundPattern);
    soundNames = strcat('subdata\',{soundlist.name}');
    
    [sound, fs] = audioread(soundNames{subnum});
    soundTime = linspace(1/fs,length(sound)/fs,length(sound));
    
    if((subnum==6)||(subnum==8)||(subnum==9)||(subnum==11))
        problem = 1;
    else
        problem = 0;
    end
    if(subnum == 13)
        [quatAngles, posAngles] = getJawAngles(fileNames{subnum},4,3,problem);
    else
        [quatAngles, posAngles] = getJawAngles(fileNames{subnum},3,4,problem);
    end
    
    time = linspace(0,endTime,endTime*100);
    toPlot= (startTime/0.01)+1:(endTime/0.01);
    soundToPlot = floor(toPlot(1)*(fs/100)):floor(toPlot(end)*(fs/100));
    figure(1);
    subplot(2,1,1)
    plot(soundTime(soundToPlot)-startTime*ones(1,length(soundTime(soundToPlot))),sound(soundToPlot))
    title('Sound Produced')
    xlabel('Time (sec)')
    ylabel('Amplitude')
    axis([0, endTime-startTime,1.05.*min(sound(soundToPlot)),1.05.*max(sound(soundToPlot))]);
    
    subplot(2,1,2)
    plot(time(toPlot)-startTime*ones(1,length(time(toPlot))),quatAngles(toPlot),'r'); 
    title('Calculated Jaw Angles')
    xlabel('Time (sec)')
    ylabel('Angle (degrees)')
    hold on
    legend
    plot(time(toPlot)-startTime*ones(1,length(time(toPlot))),posAngles(toPlot))
    legend('Orientation ','Position ','Location','Best')
    axis([0, endTime-startTime,1.05.*min(posAngles(toPlot)),0]);
    p = audioplayer(sound(soundToPlot),fs);
    playblocking(p);
end
