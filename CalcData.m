 function Res = CalcData(MainPath,UBMFile,ModelWay)
    Pr=1;
    WavFilePath = strcat(MainPath, 'TrainData\WavFiles\');
    Res=[];
    FRS = [];
    
FileList = GetFileList(WavFilePath,Pr);
N = length(FileList);
% Re=cell(N,1);
Cnt = 0;
idx = 0;

h=waitbar(0,'Этап 1/2. Расчет характеристик и гауссиан для шаблонных файлов...');
for I=1:N
    try
        waitbar(I/N,h);
    catch
        h=waitbar(I/N,'Этап 1/2. Расчет характеристик и гауссиан для шаблонных файлов...');
    end
        WavFile = strcat(WavFilePath,FileList(I).SkrName,'\',FileList(I).name);
        disp(WavFile);
        WavInfo = audioinfo(WavFile);
    
    if WavInfo.TotalSamples == 0
            idx = idx + 1;
%           EmptyWavFiles{idx,1} = idx;
%           EmptyWavFiles{idx,2} = WavFile;
    else
        try
        [Y0,Fs] = audioread(WavFile);
        catch
            continue;
        end
       
        LenWav=size(Y0,1);
        if (LenWav>20*Fs)
   
               Y=Y0(:,1);
% tm=length(Y)/Fs;
% disp(tm)
%               Block=newVAD(Y,Fs,FileList(I).name);
            Frs=NN_test_VAD(Y,Fs);
%            disp(size(Frs,2)) 
%            disp(size(Frs,2)*0.01)

%                  Frs = GetFrameFormants(Block, Y, Fs);
%                  Frs = cell2mat(Frs);
%                 Frs=GetFrames(Y,Fs,Block);
                nFrs = size(Frs,2);
               if  nFrs>500   % 500*0.01=5s
                 FRS=vertcat(FRS,Frs');
                  if I==N || FileList(I+1).No ~= FileList(I).No
 
                    Cnt = Cnt + 1;
                    TrainDataGMM  = CalcGMMap(FRS,UBMFile,ModelWay);
                    Res{Cnt,1} = TrainDataGMM;
                    Res{Cnt,2} = FileList(I).SkrName;
                    FRS=[];
                    
                  end
               end
          
       end
   end
end
close(h);

    GMMFile = strcat(MainPath,'TrainData\TrainGMMmfcc.mat' );
    save(GMMFile, 'Res');
end

