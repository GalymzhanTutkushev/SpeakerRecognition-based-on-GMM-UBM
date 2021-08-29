clear all;
clc;
% warning('off');
global MainPath;
nPos = 100;  % количество выходных файлов
srd=0;   % порог среднего
Num_pot=4;  %количество паралельных потоков

delete(gcp('nocreate'))
myPool = parpool(Num_pot);
MainPath = 'C:\Users\Галым\Desktop\newc\';

tic
disp('Расчет характеристик и гауссиан для шаблонных файлов (через мкк)...');
ResMFCC1 = CalcData(1);
toc

tic
disp('Расчет характеристик для тестовых файлов и сравнение (через мкк)...');
ResMFCC2=CmprGMM(nPos,0);
disp(ResMFCC2);
toc

