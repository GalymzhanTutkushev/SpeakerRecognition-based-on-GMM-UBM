clear;
clc;
nPos = 100;  % количество выходных файлов
Num_pot = 4;  % количество паралельных потоков
MinP = -1;
ModelWay = 0; %0-map, 1-gmm
M_llr = -0.5;
S_llr = 0.9;
MainPath = 'C:\ayanDaus\code\';
% MainPath = 'C:\Program Files\SpeakerFinder\';
UBMFile = strcat(MainPath,'UBM\GMM\G_finalUBMonNN_1024.mat');
% try
delete(gcp('nocreate'))
myPool = parpool(Num_pot);
tic
disp('Расчет характеристик и гауссиан для шаблонных файлов (через мкк)...');
ResMFCC1 = CalcData(MainPath,UBMFile,ModelWay);
toc

tic
disp('Расчет характеристик для тестовых файлов и сравнение (через мкк)...');
ResMFCC2=CmprGMM(nPos,MinP,MainPath,UBMFile, M_llr,S_llr);
disp(ResMFCC2);
toc

%% 
% plot(ResMFCC2{1:100,4})
%% 
% catch

%     errordlg('Произошла ошибка! Проверьте настройки!','Error');
% end
