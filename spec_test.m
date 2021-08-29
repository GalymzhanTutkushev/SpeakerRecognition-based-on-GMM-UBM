clc;clear;
[Y0] = audioread('zhen.wav');
signal=Y0(:,1);
[Y2,fs] = audioread('KairatA.wav');
Y2=Y2(:,1);
figure(1)
audioplayer(Y2,fs);
% [coeffs,delta,deltaDelta] = mfcc(Y2,fs);
% disp(max(Y))
% Y=signal;
% Y=Y-mean(Y);
% Y=Y/max(abs(Y));
% filtered_signal5 = Y;
% Y2=Y2-mean(Y2);
% Y2=Y2/max(abs(Y2));
% Y2 = filter([1 -0.97],1,Y2);
% disp(max(Y));
% fs=8000;
% x=0:1/fs:10;
% signal = sin(2*pi*500*x);
% figure(1);
% plot(signal);
% filtered_signal = filter(1,[1 0.97],signal);
% figure(2);
% plot(Y);
% % filtered_signal5 = filter(1,[1 0.97],Y);
% % filtered_signal5 = filter([1 -0.97],1,Y);
% figure(3);
% plot(filtered_signal5);
% title('Time-Domain signal');
% figure(4);
% nf=2048;
% fftSignal = fft(signal,nf);
% f = fs/2*linspace(0,1,nf/2+1);
% plot(f,abs(fftSignal(1:nf/2+1)));
% title('magnitude FFT of input signal');
% xlabel('Frequency (Hz)');
% ylabel('magnitude');
% figure(5)
% fftSignal2 = fft(filtered_signal,nf);
% f = fs/2*linspace(0,1,nf/2+1);
% plot(f,abs(fftSignal2(1:nf/2+1)));
% title('magnitude FFT of filtered without norm in t ');
% xlabel('Frequency (Hz)');
% ylabel('magnitude');
% figure(6)
% fftSignal5 = fft(filtered_signal5,nf);
% f = fs/2*linspace(0,1,nf/2+1);
% plot(f,abs(fftSignal5(1:nf/2+1)));
% title('magnitude FFT of filtered with norm in t');
% xlabel('Frequency (Hz)');
% ylabel('magnitude');
% FileB='b.wav';
% FileG='g.wav';
% audiowrite(FileB,filtered_signal,fs)
% audiowrite(FileG,filtered_signal5,fs)
p = floor(3*log(fs));    
DN=0.04*fs;              %длина кадра
NF=0.02*fs;    
numOFfea = 1;
FrsIN=NN_test_VAD(signal,fs);
size(FrsIN)
Fea = fea_warping(FrsIN);
figure(10);
hist(FrsIN(numOFfea,:),30);
figure(11);
hist(Fea(numOFfea,:),30);
FrsIN1=NN_test_VAD(Y2,fs);
Fea1 = fea_warping(FrsIN1);
figure(12);
hist(FrsIN1(numOFfea,:),30);
figure(13);
hist(Fea1(numOFfea,:),30);
figure(14);
plot(FrsIN(numOFfea,:),FrsIN(numOFfea+1,:),'bo');
figure(15);
plot(Fea(numOFfea,:),Fea(numOFfea+1,:),'ro');
figure(16);
plot(FrsIN1(numOFfea,:),FrsIN1(numOFfea+1,:),'b*');
figure(17);
plot(Fea1(numOFfea,:),Fea1(numOFfea+1,:),'r*');