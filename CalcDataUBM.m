 function Res = CalcDataUBM(WavFilePath,bbb,eee)
Pr=3;
FileList = GetFileList(WavFilePath,Pr);
N = length(FileList);
Re=cell(N,1);

for I=bbb:eee

        WavFile = strcat(WavFilePath,'\',FileList(I).name);
        WavInfo = audioinfo(WavFile);
    
    if WavInfo.TotalSamples == 0
%            idx = idx + 1;
           
    else
        
        [Y0,Fs] = audioread(WavFile);
        ChanCnt = size(Y0,2);
        
     for J=1:ChanCnt    
               Y=Y0(:,J);
  try
    Block=newVAD(Y,Fs);

  catch
      continue;
  end

   maxBlocks=50;
   if(size(Block,1)>maxBlocks)
       Block=Block(1:maxBlocks,:);
       beee=1;
   else
        beee=0;
   end

             if  beee==1
%                  formantsG(Block, Y, Fs);
                 Frs = GetFrameFormants(Block, Y, Fs);
                 Frs = cell2mat(Frs);
%                  nFrs = size(Frs,1); 
                  Re{I}=Frs';   
             
             end   
     end   
   end
end
       Res=Re;
%       razmerre = size(Res);