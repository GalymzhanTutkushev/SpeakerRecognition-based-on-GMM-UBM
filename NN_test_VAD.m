function  FrsOUT=NN_test_VAD(Y,Fs)
%% 
    Y=Y-mean(Y);
    Y=Y/max(abs(Y));
    p = floor(3*log(Fs));    %количество треугольных окон
    preemph = [1 -0.97];      %коэфициенты фильтрв
    DN=256;              %длина кадра
    NF=128;              %шаг сдвига кадра
    Y = filter(preemph,1,Y);
%      HighBlocks = highNorm(Y,Fs);
%      nHighBlocks = size(HighBlocks,1);
%        for ii=1:nHighBlocks
%               be=HighBlocks(ii,1);
%               en=HighBlocks(ii,2);   
             
  FrsIN = melcepst(Y,Fs,'dD',12,p,DN,NF);   % input


   FramesInBlock=0;
   NetFile = strcat('net2020.mat'); %mad30
   load(NetFile,'net');
   FrsOUT = [];
   
   speech = net(FrsIN');
   
%  plot(speech)
   ii=0;
% size(FrsIN,1)
% disp(size(FrsIN))
ef=0;sizeX=0;

      for s=1:size(FrsIN,1)-1

          if speech(s)>=0.6 && speech(s+1)>=0.6
             FramesInBlock=FramesInBlock+1;
          else

             if(FramesInBlock>5)  % 6*0.01=0.06c    0.016*5=0.08
               ii=ii+1;
              % FrsOUT=vertcat(FrsOUT,FrsIN((s-FramesInBlock):(s-1),:));   
               bf=ef+1;
               gran=size(FrsIN((s-FramesInBlock):(s-1),:));
               sizeX=gran(1)+sizeX;
               ef=bf+gran(1)-1;
               FrsOUT(bf:ef,:)=FrsIN((s-FramesInBlock):(s-1),:);
             end
            FramesInBlock=0; 
          end
      end
     
      FrsOUT=FrsOUT(1:sizeX,:);
      if size(FrsOUT,1)>1000  % 1800*0.01=18c
         FrsOUT=FrsOUT';
      else
           FrsOUT=[];
      end
     
end 

