clc;clear;
MainPath = 'D:\newc\';
WavFilePath = 'C:\Users\Галым\Desktop\вав\';
WavFile = strcat(WavFilePath,'368-17320-41442.wav');
[Y,Fs] = audioread(WavFile);
 Y=Y(:,1);
 Block=newVAD(Y,Fs)
nBlocks = size(Block,1)
figure(1);
 plot(Y);
 for I = 1:nBlocks
    Beg = Block(I,1);
    End = Block(I,2);
    Y1=Y(Beg:End);
   figure(I+1);
   plot(Y1);
  %  audiowrite(strcat('VAD',num2str(I),'.wav'),Y1,Fs);
 end
 End-Beg
