MainPath = 'D:\newc\';
WavFilePath = strcat(MainPath, 'TestData\WavFiles\');
WavFile=strcat(WavFilePath, '59F01325389F21F0.voc');
[Y0,Fs] =audioread(WavFile);
figure(1)
 
plot(Y0)
figure(2)
Y1=Y0(:,1);
  
plot(Y1)
figure(3)
Y2=Y0(:,2);
plot(Y2)
figure(4)
plot(Y1./max(Y1))
audiowrite('can1.wav',Y1,Fs)
audiowrite('can2.wav',Y2,Fs)