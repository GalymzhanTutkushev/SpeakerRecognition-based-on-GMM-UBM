function Res = EstimateGMM(Pr)

global MainPath;

GMMCount=32; %количество компонент GMM
%Настройки для расчета GMM
Opt = statset('Display','off','TolFun',0.001);
tau = 18.0;
config = 'm';
UBMFile = strcat(MainPath,'UBM\GMM\UBM_GMM.mat');
UBM_GMM = load(UBMFile, 'GMModel');
UBM = UBM_GMM.GMModel;

IterCnt = 200;
ds_factor = 1; 
nworkers = 4;

if Pr==1
    GMMPath = strcat(MainPath, 'TrainData\GMM\');
    DataFileDir = strcat(MainPath, 'TrainData\Data\');
else
    GMMPath = strcat(MainPath, 'TestData\GMM\');
    DataFileDir = strcat(MainPath, 'TestData\Data\');
end;

FileList = dir(DataFileDir);

for I=1:length(FileList)
    if FileList(I).isdir() == 0
        GMMFile = strcat(GMMPath,FileList(I).name(1:end-4),'.mat');
        %Проверим, рассчитаны ли уже GMM текущего спикера
        if exist(GMMFile, 'file') == 0
            DataFile = strcat(DataFileDir,FileList(I).name);
            V = load(DataFile);
            Data = V(:,5:40);
            try
                %Расчет GMM
                %GMModel = gmdistribution.fit(Data,GMMCount, 'CovType', 'diagonal', 'Options',Opt);
                 Data = mat2cell(Data');
%                 GMModel = mapAdapt(Data, UBM, tau, config);
                 GMModel = gmm_em(Data, GMMCount, IterCnt, ds_factor, nworkers);
                save(GMMFile, 'GMModel');
            catch exception
                disp(DataFile);
            end;
        end;
    end;
end;
Res=1;