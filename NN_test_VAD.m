function  FrsOUT=NN_test_VAD(Y,Fs)
%% 
    C = [];
    p = floor(3*log(Fs));    %количество треугольных окон
    preemph = [1 0.97];      %коэфициенты фильтрв
    DN=0.02*Fs;              %длина кадра
    NF=0.01*Fs;              %шаг сдвига кадра
    YY = [];
     HighBlocks = highNorm(Y,Fs);
     nHighBlocks = size(HighBlocks,1);
       for ii=1:nHighBlocks
              be=HighBlocks(ii,1);
              en=HighBlocks(ii,2);
                   Y = filter(1,preemph,Y);
                    Y0=Y(be:en);
                    Y0=Y0-mean(Y0);
                    Y0=Y0/max(abs(Y0));    % нормировка
                    
                    FrsCell = melcepst(Y0,Fs,'dD',12,p,DN,NF);   % input
 
             C = vertcat(C,FrsCell); 
            
       end

   FrsIN=C';

   FramesInBlock=0;
   NetFile = strcat('finalNet2019.mat');
   load(NetFile,'net');
   FrsOUT = [];
   speech = net(FrsIN);

   ii=0;

%      len = length(FrsIN);
      for s=1:length(FrsIN)-1

          if speech(s)>=0.8 && speech(s+1)>=0.8
             FramesInBlock=FramesInBlock+1;
       
          else

             if(FramesInBlock>10)  % 10*0.02=0.2c
               ii=ii+1;
               FrsOUT=vertcat(FrsOUT,C((s-FramesInBlock):(s-1),:));       
             YY=vertcat(YY,Y(Begin:End));
             end

            FramesInBlock=0;
            
          end
   
      end
      
      if size(FrsOUT,1)>1000  % 1000*0.02=20c
         FrsOUT=FrsOUT';
      else
           FrsOUT=[];
      end
  disp(YY)
audiowrite('D:\Galym stuff\matal\audio2019\output.wav',YY,Fs)   
end 

