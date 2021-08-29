 MainPath = 'D:\newc\';
 WavFilePath = strcat(MainPath, 'TestData\WavFiles\');
 FileList = GetFileList(WavFilePath,2);
 N = length(FileList);

 for I=1:1
%      WavFile = strcat(WavFilePath,'\',FileList(I).name);
 WavFile =  'D:\newc\TestData\WavFiles\10780-23900-35923.wav';
     WavInfo = audioinfo(WavFile)
      [Y0,Fs] = audioread(WavFile);
      plot(Y0)
      sound(Y0)
     if(WavInfo.CompressionMethod=='A-law')
         x=pcma2lin(Y0)
     end
 end