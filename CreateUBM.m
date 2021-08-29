function CreateUBM(MainPath,IterCnt,nworkers,GMMCount)
% clear all;
% clc;

%% Step0: Settings

delete(gcp('nocreate'))
parpool(nworkers);
% global MainPath;
warning('off');
% MainPath = 'D:\newc\';
GMMPath = strcat(MainPath, 'UBM\GMM\');

% GMMCount = 2048;
% IterCnt = 20;
Pr=3;
ds_factor = 1; 
% nworkers = 8;
  nMax = 5000;
% Opt = statset('Display','off','TolFun',0.001);

%% Step1: Calculating features (mfcc, delta-mfcc, delta-delta-mfcc)
  

disp('¬ычисл€ютс€ характеристики фоновых дикторов');
tic;
WavFilePath = strcat(MainPath, 'UBM\WavFiles-2\');
FileList = GetFileList(WavFilePath,Pr);
N = length(FileList);
nnn=round(N/nMax);
for i=1:nnn
UBM_DataFile = strcat(MainPath, 'UBM\Data\UbmData2048new-',num2str(i),'.mat');
WavFilePath = strcat(MainPath, 'UBM\WavFiles-2\');
if exist(UBM_DataFile, 'file') == 0
    bbb=(i-1)*nMax+1;
    eee=i*nMax;
    if(eee>N)
        eee=N;
    end
    DataList = CalcDataUBM(WavFilePath,bbb,eee);
    DataList = DataList(~cellfun('isempty',DataList)); 
    [m,n]=size(DataList);
    save(UBM_DataFile, 'DataList');
% else
%     V=load(UBM_DataFile,'DataList');
%      DataList = V.DataList; 
%      clear V;
end

end
toc;
% Num_parts=m/nMax;
% Data=cell(Num_parts,1);
% for p=1:Num_parts
%     Data{p}=DataList((p-1)*nMax+1:p*Nmax);
% end

%% Step2: Calculate GMM for UBM

 disp('¬ычисл€етс€ GMM дл€ фоновых дикторов (UBM)');
% % DataList = mat2cell(DataList',n,m);
tic;
 GMModel = gmm_em_bigUBM(GMMCount, IterCnt, ds_factor, nworkers,nnn,MainPath);
% %GMModel = gmdistribution.fit(DataList,GMMCount, 'CovType', 'diagonal', 'Options',Opt);
%  clear DataList;
 GMMFile = strcat(GMMPath,'UBM_parallel_2048.mat');
 save(GMMFile, 'GMModel');
toc;