function GMModel = CalcGMMap(Data)
global MainPath;
% GMMCount=32; %количество компонент GMM
%Настройки для расчета GMM
% Opt = statset('Display','off','TolFun',0.001);
tau = 19.0;
config = 'mvw';
% IterCnt = 200;
% ds_factor = 1; 
% nworkers = 4;
    UBMFile = strcat(MainPath,'/UBM/GMM/UBM.mat');
   UBM_GMM = load(UBMFile, 'GMModel');
   UBM = UBM_GMM.GMModel;

[Ms,Ns]=size(Data);
    Data = mat2cell(Data',Ns,Ms);
    
  %  GMModel = gmm_em(Data, GMMCount, IterCnt, ds_factor, nworkers);    
   GMModel = mapAdapt(Data, UBM, tau, config);

    
end
    