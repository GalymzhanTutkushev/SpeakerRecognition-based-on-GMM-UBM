clear;
clc;
nPos = 100;  % ���������� �������� ������
Num_pot = 4;  % ���������� ����������� �������
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
disp('������ ������������� � �������� ��� ��������� ������ (����� ���)...');
ResMFCC1 = CalcData(MainPath,UBMFile,ModelWay);
toc

tic
disp('������ ������������� ��� �������� ������ � ��������� (����� ���)...');
ResMFCC2=CmprGMM(nPos,MinP,MainPath,UBMFile, M_llr,S_llr);
disp(ResMFCC2);
toc

%% 
% plot(ResMFCC2{1:100,4})
%% 
% catch

%     errordlg('��������� ������! ��������� ���������!','Error');
% end
