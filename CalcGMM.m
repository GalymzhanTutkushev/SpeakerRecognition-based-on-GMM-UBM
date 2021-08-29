function GMModel = CalcGMM(Data)
GMMCount=32; %количество компонент GMM
%Настройки для расчета GMM
Opt = statset('Display','off','TolFun',0.001);
tau = 18.0;
config = 'm';
IterCnt = 100;
ds_factor = 1; 
nworkers = 4;
     
%  try
[Ms,Ns]=size(Data);
    Data = mat2cell(Data',Ns,Ms)
    size(Data);
    GMModel = gmm_em(Data, GMMCount, IterCnt, ds_factor, nworkers);              
%  catch exception
%     disp('error');
%  end;
    
end
    