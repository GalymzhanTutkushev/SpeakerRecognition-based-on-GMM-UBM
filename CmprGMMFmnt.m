function Res = CmprGMM(nPos)
   global MainPath;
   S1 = '%5.0f %12.0f %12.0f %8.2f';
   S2 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f'; 
   S3 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
   S4 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
   S5 = '\r\n';
   Str = strcat(S1,S2,S3,S4,S5);
   
   %%
   WavFilePath = strcat(MainPath, 'TestData\WavFiles\');
   DataFileDir = strcat(MainPath, 'TestData\Dataf\');
   %%
   UBMFile = strcat(MainPath,'UBM\GMM\UBM_parallel_1024_30000_formants.mat');
   UBM_GMM = load(UBMFile, 'GMModel');
   UBM = UBM_GMM.GMModel;
   %%
   GMMFile = strcat(MainPath, 'TrainData\TrainGMMfmnt.mat');
   TrainDataGMM = load(GMMFile);
   M = size(TrainDataGMM.Res,1);
   TGMM = TrainDataGMM.Res;
   %%
   trials = [1 1];
   R=cell(1,4);
   Cnt = 0;
   CntJ = 0;
   
   FileList = GetFileList(WavFilePath,2)
   N = length(FileList)
   iii=0;
   for I=1:N %цикл для тестовых файлов
       
       WavFile = strcat(WavFilePath,FileList(I).name);
        try 

[Y0,Fs] = audioread(WavFile);

 catch      
            iii=iii+1;
           continue;
           
        end
       ChanCnt = size(Y0,2);
      len = size(Y0,1);
      if (len>260000 )
      for J=1:ChanCnt %цикл для двух каналов
          Y=Y0(:,J);
       if ~all(Y==0)
          
%           Y=Y./max(Y);
%          Y = length_norm(Y);
            %%%%%%%%%%%%%% предобработку сюда
            
  [Yf,Blocks,fff]=betterVAD(Y,Fs);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
          if (size(Blocks,1) > 5  ) 
              
%                 [Frs,DN] = GetFrameFormants(Blocks, Y, Fs);
                 
%               Frs =  formantsG(Yf, Fs);
     preemph = [1 0.97];%коэфициенты фильтрв
     
     Y=Y - mean(Y);                 %центрируем сигнал
     Y = filter(1,preemph,Y);
     Frs = CalcFormants(Y,Fs,fff);
     
              TestData = Frs;
                size(TestData);
               
%                  TestData=vertcat(FRS,TestData);
                DataFile = strcat(DataFileDir,mat2str(J),FileList(I).SkrName,'.txt');
                FileName = strcat(mat2str(J),FileList(I).SkrName);
                
                fid=fopen(DataFile,'w');
                fprintf(fid,Str,TestData');
                fclose(fid);
                
                %TestGMM = CalcGMM(TestData);       
                nT=size(TestData,1);
                [Mm,Nn]=size(TestData);

                 TestData = mat2cell(TestData',Nn,Mm);

                CntJ = CntJ + 1;

               parfor (II=1:1)  %цикл для GMM шаблонных файлов
                    
                    modelGMM = TGMM(1,1)
                    dy = score_gmm_trials(modelGMM, TestData, trials, UBM)

                    Idx = find(dy>0);
                    Sim = 100*numel(Idx)/nT;
                    isscalar(Sim);

                    R1(II) = II;
                    %R2(II) = CntJ;
                     R3(II) = Sim
                    R2(II) = mean(dy);
%                      R3(II) = dy;
                    R4(II) = {FileName};
                    
               end
               
                 for idx = 1:1
                    if R3(idx) > 0 
                    Cnt = Cnt + 1;
                    R(Cnt,1) = {R1(idx)};
                    R(Cnt,2) = {R2(idx)};
                    R(Cnt,3) = {R3(idx)};
                    R(Cnt,4) = R4(idx);
                    end
                 end
          else
              iii=iii+0.5;
          end
       else
           iii=iii+0.5;
      end
      end
      else
          iii=iii+1;
          
    WavInfo = audioinfo(WavFile)
      end
       
   end
 iii
 R = sortrows(R,[1 -3]);
 
 RESFile = strcat(MainPath,'Results\ResFMNT.mat' );
    save(RESFile, 'R');
    
n=size(R,1)
Cur = 0;
J=0;
K=0;
Res=cell(1,4);
for I=1:n
    if R{I,1}~=Cur
        Cur=R{I,1};
        K=1;
        
        if I~=1
            J=J+1;
            Res{J,1} = '---------';
            Res{J,2} = '---------';
            Res{J,3} = '-100';
        end
    else
        K=K+1;
    end
    if K<=nPos
        J=J+1;

        Res{J,1}= TrainDataGMM.Res{R{I,1},2};
        Res{J,2} = R{I,4};
        Res{J,3} = R{I,3};
        Res{J,4} = R{I,2};

    end
end
end