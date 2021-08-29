function GMModel = CalcGMMap(Data,UBMFile,mode)

if mode == 0
    tau = 0.1;
    config = 'm'; % лучше адаптировать только средние значения
    UBM_GMM = load(UBMFile, 'GMModel');
    UBM = UBM_GMM.GMModel;  
    [Ms,Ns]=size(Data);
    Data = mat2cell(Data',Ns,Ms);  
    GMModel = mapAdapt(Data, UBM, tau, config); 
else
    GMMCount=64; %количество компонент GMM
    IterCnt = 100;
    ds_factor = 1; 
    nworkers = 4;

    [Ms,Ns]=size(Data);
    Data = mat2cell(Data',Ns,Ms);
    GMModel = gmm_em(Data, GMMCount, IterCnt, ds_factor, nworkers);    
end  
end
    