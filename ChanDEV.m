global MainPath;
    WavFilePath = strcat(MainPath, 'TrainData\WavFiles\');
    DataFileDir = strcat(MainPath, 'TrainData\Data\');
  Pr=1;
FileList = GetFileList(WavFilePath,Pr);

S1 = '%5.0f %12.0f %12.0f %8.2f';
S2 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
S3 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
S4 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
S5 = '\r\n';
Str = strcat(S1,S2,S3,S4,S5);
T1 = 0;
T2 = 0;
N = length(FileList);
Cnt = 0;
idx = 0;
for I=1:N
    if Pr==1
        WavFile = strcat(WavFilePath,FileList(I).SkrName,'\',FileList(I).name);
    else
        WavFile = strcat(WavFilePath,FileList(I).SkrName,'\',FileList(I).name);
    end
    
    WavInfo = audioinfo(WavFile);
    
    if WavInfo.TotalSamples == 0
          idx = idx + 1;
          EmptyWavFiles{idx,1} = idx;
          EmptyWavFiles{idx,2} = WavFile;
    else
        
        [Y0,Fs] = audioread(WavFile);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ChanCnt = size(Y0,2);
        ToDo = 0;
     for J=1:ChanCnt
          

 
               Y=Y0(:,J);
               JJ=num2str(J);
               II=num2str(I);
              dd=strcat('C:\Users\Галым\Desktop\devWAV\','TrNO',II,'Chan',JJ,'.wav');
audiowrite(dd,Y,Fs)
    
           
         
     end
    end
end
