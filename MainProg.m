clear all;
clc;
% warning('off');
global MainPath;
nPos = 100;  % ���������� �������� ������
srd=0;   % ����� ��������
Num_pot=4;  %���������� ����������� �������

delete(gcp('nocreate'))
myPool = parpool(Num_pot);
MainPath = 'C:\Users\�����\Desktop\newc\';

tic
disp('������ ������������� � �������� ��� ��������� ������ (����� ���)...');
ResMFCC1 = CalcData(1);
toc

tic
disp('������ ������������� ��� �������� ������ � ��������� (����� ���)...');
ResMFCC2=CmprGMM(nPos,0);
disp(ResMFCC2);
toc

