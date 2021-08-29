function Res = CmprGMM(nPos,MinP,MainPath,UBMFile, M_llr,S_llr, handles)
%    global MainPath;
% MinP=0;
   %%
   WavFilePath = strcat(MainPath, 'TestData\WavFiles\');

   %%  
%   
   UBM_GMM = load(UBMFile, 'GMModel');
   UBM = UBM_GMM.GMModel;
   %%
   GMMFile = strcat(MainPath, 'TrainData\TrainGMMmfcc.mat');
   TrainDataGMM = load(GMMFile);
   M = size(TrainDataGMM.Res,1);
   TGMM = TrainDataGMM.Res;
   
   %%
   R=cell(1,5);
   nMax = 1010;
   ResAll=[];

%  R1=zeros(M,1);R2=zeros(M,1);R3=zeros(M,1);R4=cell(M,1); 
   FileListALL = GetFileList(WavFilePath,2); 
   disp(FileListALL)
   N = length(FileListALL);
if nMax>N
    nMax=N;
end
h=waitbar(0,'Этап 2/2.Расчет характеристик для тестовых файлов и сравнение...');
nnn=round(N/nMax);
tstop=[];
for i=1:nnn
    if i==2
     ostime=strcat('Приблизительное время расчета: ', num2str(fix(tstop*(nnn-1))),'  секунд...');
     msgbox(ostime);
    end
    try
       waitbar(i/nnn,h);
    catch
        h=waitbar(i/nnn,'Этап 2/2.Расчет характеристик для тестовых файлов и сравнение...');
    end
 tstart=tic;

      bbb=(i-1)*nMax+1;
      eee=i*nMax;
    if(eee>N)
     eee=N;
     nMax=N-nMax*(i-1);
    end

   FrsCell_ch1 = cell(1,nMax);      
   FileName_ch1= cell(1,nMax);
   FrsCell_ch2 = cell(1,nMax);      
   FileName_ch2= cell(1,nMax);
   FileList = FileListALL(bbb:eee);
   parfor  I=1:nMax    %цикл для тестовых файлов        
      
       
         WavFile = strcat(WavFilePath,FileList(I).name);
%        WavFile = strcat(WavFilePath,'test7.wav');
        try 
           [Y0,Fs] = audioread(WavFile);
        catch            
           continue; 
        end
       % Nmax=300*Fs;
       %  if size(Y0,1)>Nmax
                
         %  Y0=Y0(1:Nmax,:);
                    
       %  end
        ChanCnt = size(Y0,2);
        len = size(Y0,1);
        if (len>50*Fs)
          
          if ChanCnt==1
               Y1=Y0(:,1);
      

            if ~all(Y1==0)
                    FrsCell_ch1{I}=NN_test_VAD(Y1,Fs);
%                     Block=newVAD(Y1,Fs);                         
%                     FrsCell_ch1{I} = GetFrames(Y1, Fs,Block);   
                  if ~isempty(FrsCell_ch1{I})
                    FileName_ch1{I} = strcat(mat2str(1),FileList(I).SkrName);
                  end
                    
            end  
          else
              
               Y2=Y0(:,1);
      

             if ~all(Y2==0)
                     FrsCell_ch1{I}=NN_test_VAD(Y2,Fs);
%                      Block=newVAD(Y2,Fs,FileList(I).name);                         
%                     FrsCell_ch1{I} = GetFrames( Y2, Fs,Block); 
                     if ~isempty(FrsCell_ch1{I})
                        FileName_ch1{I} = strcat(mat2str(1),FileList(I).SkrName);
                     end
             end 
             Y3=Y0(:,2);
      
 
             if ~all(Y3==0)
                    
%                     Block=newVAD(Y3,Fs); 
                     FrsCell_ch2{I}=NN_test_VAD(Y3,Fs);
%                     FrsCell_ch2{I} = GetFrames(Y3, Fs,Block);   
                 if ~isempty(FrsCell_ch2{I})
                    FileName_ch2{I} = strcat(mat2str(2),FileList(I).SkrName);
                 end
             end  
           end
                  
        end    
   end
   
    FrsCell=vertcat(FrsCell_ch1',FrsCell_ch2');
    FileName=vertcat(FileName_ch1',FileName_ch2');
    
   clear Fs;
   clear Y0;
%     trials=[];
%     tests=1:2*nMax;
%     tests=tests';
%      models=ones(2*nMax,1);
%                          for II=1:M
%                            trial = [II*models tests]; 
%                            trials=vertcat(trials,trial);
%                          end
         trials=[2*nMax,1];
         TestData=FrsCell;
                      
                        
   for II=1:M  %цикл для GMM шаблонных файлов MODELS
          models=II*ones(2*nMax,1);
          modelGMM = TGMM(II,1); 
          [Sim,srednee,sigma,SS,ST] = score_gmm_trials(modelGMM, TestData, trials, UBM, M_llr,S_llr);
          disp("srednee")
          disp(SS)
          disp("otklonenie")
          disp(ST)
          id=find(Sim>MinP);
        kol=numel(id);
        models=num2cell(models);
        srednee=num2cell(srednee);
        sigma=num2cell(sigma);
%         dispers=num2cell(dispers); 
        Sim=num2cell(Sim); 
        br=1;
        er=2*nMax;
          R(br:er,1)=models;
          R(br:er,4)=srednee;
          R(br:er,3)=Sim;
          R(br:er,2)=FileName;
          R(br:er,5)=sigma;
%           R(br:er,5)=dispers;
              if(~isempty(R))
               R = sortrows(R,[1 -4]);  % отсортировали по моделям и по убыванию соответствия 
               R = R(1:kol,:);
              end           
     ResAll=vertcat(ResAll,R);
   
   end
%                         toc;
%                         disp('dy'); disp(dy);
%                          for II=1:M  %цикл для GMM шаблонных файлов MODELS 
% %                          Id1 = find(dy>0&dy<0.5);
% %                          Id2 = find(dy>=0.5&dy<1);   
% %                          Id3 = find(dy>=1);
% %                          Idx = 0.25*numel(Id1)+0.75*numel(Id2)+numel(Id3);
% %                          Sim = 100*Idx/nC;
%           
%                     R1(II) = II;
%                     R3(II) = srednee;
%                     R2(II) = srednee;
%                     R4(II) = FileName;
%                         end
%               
%                  for idx = 1:M
%                     if (R3(idx)>MinP) 
%                     Cnt = Cnt + 1;
%                     R(Cnt,1) = {R1(idx)};
%                     R(Cnt,2) = {R2(idx)};
%                     R(Cnt,3) = {R3(idx)};
%                     R(Cnt,4) = R4(idx);
%                     end
%                  end
%   set(handles.uitable1,'Data',ResAll);  
  try
         ResAll = sortrows(ResAll,[1 -4]);  % отсортировали по моделям и по убыванию соответствия 
         RESFile = strcat(MainPath,'Results\ResMFCC.mat' );
         save(RESFile, 'ResAll');
 catch
  end
%    set(handles.uitable1,'Data',ResAll);
%      if i>1
%      CalcDataADD(MainPath,UBMFile);
%      end
     tstop=toc;
end
 R=ResAll;
 close(h);
   if(~isempty(R))
    R = sortrows(R,[1 -4]);  % отсортировали по моделям и по убыванию соответствия 
    RESFile = strcat(MainPath,'Results\ResMFCC.mat' );
    save(RESFile, 'R');
    
n=size(R,1);
Cur = 0;
J=0;
K=0;
Res=cell(1,5);
for I=1:n
    if  R{I,1}~=Cur     % если началась новая модель
        Cur=R{I,1};
        K=1;            % начни считать сначала
        
        if I~=1         % после первой модели вывести разделительную полосу
            J=J+1;        
            Res{J,1} = '---------';
            Res{J,2} = '---------';
            Res{J,3} = strcat( '-',num2str(nPos));
        end
    else
        K=K+1;
    end
    if K<=nPos    % раздельно 
        J=J+1;
        Res{J,1}= TrainDataGMM.Res{R{I,1},2};
        Res{J,2} = R{I,2};
        Res{J,3} = R{I,3};
        Res{J,4} = R{I,4};
        Res{J,5} = R{I,5};
    end
end
    RESFile = strcat(MainPath,'Results\Res.mat' );
    save(RESFile, 'Res');
    else
       msgbox('Совпадений не найдено');
       Res=0;
    end
end
       
       