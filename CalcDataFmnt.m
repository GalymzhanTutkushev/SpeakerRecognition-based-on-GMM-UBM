 function Res = CalcDataFmnt(Pr)
global MainPath;
if Pr==1 %for training data
    WavFilePath = strcat(MainPath, 'TrainData\WavFiles\');
    DataFileDir = strcat(MainPath, 'TrainData\Data\');
    Res=[];
    FRS = [];
elseif Pr==2 %for testing data
    WavFilePath = strcat(MainPath, 'TestData\WavFiles\');
    DataFileDir = strcat(MainPath, 'TestData\Dataf\');
    Res={1};
elseif Pr==3 %for UBM
    WavFilePath = strcat(MainPath, 'UBM\WavFiles-2\');
    Re=[];
end

FileList = GetFileList(WavFilePath,Pr);

S1 = '%5.0f %12.0f %12.0f %8.2f';
S2 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
S3 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
S4 = ' %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f';
S5 = '\r\n';
Str = strcat(S1,S2,S3,S4,S5);
T1 = 0;
T2 = 0;
N = length(FileList);
Re=cell(N,1);
Cnt = 0;
idx = 0;



for (I=1:N)
%      try
 
%     myFiles = {'D:\newc\betterVAD.m', 'D:\newc\GetFrameFormants.m'};
%     addAttachedFiles('local', myFiles);

    if Pr==1
        WavFile = strcat(WavFilePath,FileList(I).SkrName,'\',FileList(I).name);
    else
        WavFile = strcat(WavFilePath,'\',FileList(I).name);
    end
    
    WavInfo = audioinfo(WavFile);
    
    if WavInfo.TotalSamples == 0
%           idx = idx + 1;
%           EmptyWavFiles{idx,1} = idx;
%           EmptyWavFiles{idx,2} = WavFile;
    else
        
        [Y0,Fs] = audioread(WavFile);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ChanCnt = size(Y0,2);
        LenWav=size(Y0,1);
        ToDo = 1;
        if (LenWav>15*8000)
     for J=1:ChanCnt
           
            

        %Если требуется расчитать характеристики текущего wav файла
            if ToDo == 1
               Y=Y0(:,J);
            
                %%%%%%%%%%%%%% предобработку сюда
 preY=size(Y);
%  try
    [Yf,Block,fff]=betterVAD(Y,Fs);

%  catch
%      continue;
%  end



             if size(Block,1) > 7
%                  if beee==1
%                  Frs = GetFrameFormants(Block, Y, Fs);
%                  Frs =  formantsG(Yf, Fs);

     preemph = [1 0.97];%коэфициенты фильтрв
     
     Y=Y - mean(Y);                 %центрируем сигнал
     Y = filter(1,preemph,Y);
     Frs = CalcFormants(Y,Fs,fff);
              % catch
                 %disp(WavFile);
               %   idx = idx + 1;
                
%  EmptyWavFiles{idx,1} = idx;
 %                 EmptyWavFiles{idx,2} = WavFile;
  %               continue;
   %            end;
%                Frs = cell2mat(Frs);
               
       
               
               
               nFrs = size(Frs,1);
               if Pr==1 && nFrs>10 && J==1
                 FRS=vertcat(FRS,Frs);
                 if I==N || FileList(I+1).No ~= FileList(I).No
                    DataFile = strcat(DataFileDir,FileList(I).SkrName,'.txt');
                    fid=fopen(DataFile,'w');
                    fprintf(fid,Str,FRS');
                    fclose(fid);
                    
                    Cnt = Cnt + 1;
                    TrainDataGMM  = CalcGMMapFmnt(FRS);
                    Res{Cnt,1} = TrainDataGMM;
                     Res{Cnt,2} = FileList(I).SkrName;
                    FRS=[];
                 end
               end

             end
             
            end
     end
          end
%      catch 
%          continue;
       
       
 end
end

if Pr == 1
    GMMFile = strcat(MainPath,'TrainData\TrainGMMfmnt.mat' );
    save(GMMFile, 'Res');
end

