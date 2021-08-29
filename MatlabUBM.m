clear;clc;
Ncom = 12;
FRS = [];
tic;
PathSpeech='C:\ayanDaus\UBMtrainWAV';
FileList = GetFileList(PathSpeech,3);
N = length(FileList);
for I=1:N
    WavFile = strcat(PathSpeech,'\',FileList(I).name);
    disp(WavFile);
    [Y0,fs] = audioread(WavFile);
    ChanCnt = size(Y0,2);
    for J=1:ChanCnt    
        signal=Y0(:,J);
        FrsIN=NN_test_VAD(signal,fs);
        FRS=vertcat(FRS,FrsIN');
    end
end
disp(size(FRS));
disp(size(FRS,1)*128/8000/60/60);
options = statset('MaxIter',1000);

koms = [1 2 4 8 16 32 64 128 256 512 1024];
AIC = zeros(1,length(koms));
BIC = zeros(1,length(koms));
GMModels = cell(1,length(koms));
try
for i = 1:length(koms)
    k=koms(i);
    GMModels{i} = fitgmdist(FRS,k,'Options',options,'CovarianceType','diagonal');
    AIC(i)= GMModels{i}.AIC;
    BIC(i)= GMModels{i}.BIC;
end
catch
    disp('warn')
end
figure(1);
plot(koms,AIC,'r-o');
title('AIC')
figure(2);
plot(koms,BIC,'b-*');
title('BIC')
[minAIC,numComponents] = min(AIC);
disp(numComponents);
[minBIC,numComponentsB] = min(BIC);
disp(numComponentsB);
toc;