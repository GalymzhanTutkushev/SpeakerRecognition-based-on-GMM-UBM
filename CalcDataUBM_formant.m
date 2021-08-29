 function Res = CalcDataUBM_formant(WavFilePath)
Pr=3;
FileList = GetFileList(WavFilePath,Pr)
N = length(FileList)
Re=cell(N,1);
idx=0;
parfor I=1:N

        WavFile = strcat(WavFilePath,'\',FileList(I).name);
        WavInfo = audioinfo(WavFile);
    
    if WavInfo.TotalSamples == 0
           idx = idx + 1;
           WavFile;
    else
        
        [Y0,Fs] = audioread(WavFile);
        ChanCnt = size(Y0,2);
        
     for J=1:ChanCnt    
               Y=Y0(:,J);
  try
    [Y,Block]=betterVAD(Y,Fs);

  catch
      continue;
  end

   maxY=200000;
   if(size(Y,1)>maxY)
       Y=Y(1:maxY,:);
       beee=1;
   else
        beee=0;
   end
% size(Block,1) > 10 &&
             if  beee==1
               Frs =  formantsG(Y, Fs);
%                  Frs = GetFrameFormants(Block, Y, Fs,fff);

%                  Frs = cell2mat(Frs);
                 if (~all(Frs == 0))
                 nFrs = size(Frs,1); 
                  Re{I}=Frs';   
                 end
             end   
     end   
    end
end
       Res=Re;
      razmerre = size(Res)