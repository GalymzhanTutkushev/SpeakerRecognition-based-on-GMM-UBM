function Res = CmprGMM(nPos,MinP)
   global MainPath;

   %%
   WavFilePath = strcat(MainPath, 'TestData\WavFiles\');
%    DataFileDir = strcat(MainPath, 'TestData\Data\');
   %%
   UBMFile = strcat(MainPath,'UBM\GMM\UBM.mat');
   UBM_GMM = load(UBMFile, 'GMModel');
   UBM = UBM_GMM.GMModel;
   %%
   GMMFile = strcat(MainPath, 'TrainData\TrainGMMmfcc.mat');
   TrainDataGMM = load(GMMFile);
   M = size(TrainDataGMM.Res,1);
   TGMM = TrainDataGMM.Res;
   %%
    trials = [1 1];
   R=cell(1,4);
   Cnt = 0;
%    CntJ = 0;
   R1=zeros(M,1);R2=zeros(M,1);R3=zeros(M,1);R4=cell(M,1);
   FileList = GetFileList(WavFilePath,2)
   N = length(FileList);
%   FRS=[];
   for I=1:N %цикл для тестовых файлов
%        
         WavFile = strcat(WavFilePath,FileList(I).name);
%     WavFile = strcat(WavFilePath,'test7.wav');
        try 
[Y0,Fs] = audioread(WavFile);
        catch            
           continue;   
        end
       ChanCnt = size(Y0,2);
       len = size(Y0,1);
      if (len>35*Fs)
        for J=1:ChanCnt %цикл для двух каналов
          Y=Y0(:,J);
       if ~all(Y==0)     
  Blocks=newVAD(Y,Fs);   %параллельно
     Frs = GetFrameFormants(Blocks, Y, Fs);     %параллельно
                     TestData = cell2mat(Frs);
                     [Mm,Nn]=size(TestData);
                     nT=size(TestData,1);
                     TestData = mat2cell(TestData',Nn,Mm);

          if (size(Blocks,1) > 5 ) 
              
                FileName = strcat(mat2str(J),FileList(I).SkrName);
                for II=1:M  %цикл для GMM шаблонных файлов MODELS             
                    modelGMM = TGMM(II,1);
                  dy = score_gmm_trials(modelGMM, TestData, trials, UBM);

                    Idx = find(dy>0);
                    Sim = 100*numel(Idx)/nT;
%                     NN=mm+nn;
%                     Sim=mm/NN*100;   
                    R1(II) = II;
                    R3(II) = mean(dy);
                    R2(II) = Sim;
                    R4(II) = {FileName};
                end

                 for idx = 1:M
                    if (R3(idx)>MinP) 
                    Cnt = Cnt + 1;
                    R(Cnt,1) = {R1(idx)};
                    R(Cnt,2) = {R2(idx)};
                    R(Cnt,3) = {R3(idx)};
                    R(Cnt,4) = R4(idx);
                    end
                 end
         
          end
       
        end
        end
      end
       
   end
   if(~isempty(R))
 R = sortrows(R,[1 -3]);  % отсортировали по моделям и по убыванию соответствия 
 
    RESFile = strcat(MainPath,'Results\ResMFCC.mat' );
    save(RESFile, 'R');
    
n=size(R,1);
Cur = 0;
J=0;
K=0;
Res=cell(1,4);
for I=1:n
    if  R{I,1}~=Cur     % если началась новая модель
        Cur=R{I,1};
        K=1;            % начни считать сначала
        
        if I~=1         % после первой модели вывести разделительную полосу
            J=J+1;        
            Res{J,1} = '---------';
            Res{J,2} = '---------';
            Res{J,3} = '-100';
        end
    else
        K=K+1;
    end
    if K<=nPos    % раздельно сделать
        J=J+1;
        Res{J,1}= TrainDataGMM.Res{R{I,1},2};
        Res{J,2} = R{I,4};
        Res{J,3} = R{I,3};
        Res{J,4} = R{I,2};
    end
end
   
   else
       disp('Совпадений не найдено');
       Res=0;
    end
end
       
       