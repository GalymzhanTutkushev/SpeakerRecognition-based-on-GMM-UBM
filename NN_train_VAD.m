function [C,ID_in]=NN_train_VAD()
%% 
C = [];ID_in=[];

succes=0;
PathSpeech='C:\Users\User\Desktop\matal\shahALL\';
FileListS = GetFileList(PathSpeech,2);
Nfiles = length(FileListS);
for I=1:Nfiles
    WavFileS = strcat(PathSpeech,FileListS(I).name);
 disp(WavFileS)
  if WavFileS(end-3:end)=='.wav'
    [Y,Fs] = audioread(WavFileS);
    XlsData = strcat(PathSpeech,FileListS(I).name(1:end-4),'.xlsx');
 
 
    Chan=size(Y,2);
    p = floor(3*log(Fs));    %количество треугольных окон
    preemph = [1 0.97];      %коэфициенты фильтрв
    DN=0.02*Fs;              %длина кадра
    NF=0.01*Fs;              %шаг сдвига кадра
    Y = filter(1,preemph,Y);
     
    for j=1:Chan
         
     Blocks = xlsread(XlsData,j);
     N=size(Blocks,1);
     Yc=Y(:,j);
     HighBlocks = highNorm(Yc,Fs);
     nHighBlocks = size(HighBlocks,1);
    for ii=1:nHighBlocks
              be=HighBlocks(ii,1);
              en=HighBlocks(ii,2);
                 
         
          for i=1:N
           if  ~isnan(Blocks(i,3))
        
                b=Blocks(i,1);
                e=Blocks(i,2);
             if i==1 && isnan(b) && isnan(e)
                 b=1;
                 e=Blocks(i+1,1);
             end
             if isnan(b) && isnan(e) && i>1
                b=Blocks(i-1,2);
                e=Blocks(i+1,1);
             end 
       
             if be>=b && be<e
              if b<=be 
                  if e>en 
                   
                    Y0=Y(be:en,j);
                    Y0=Y0-mean(Y0);
                    Y0=Y0/max(abs(Y0));    % нормировка
                    
                    FrsCell = melcepst(Y0,Fs,'dD',12,p,DN,NF);   % input
                  
                     if(Blocks(i,3)==1)
                     s_ID=ones(size(FrsCell,1),1);
                     else
                     s_ID=zeros(size(FrsCell,1),1);
                     end
                    
                     
                  else
           
                       if e-be>DN
                           Y1=Y(be:e,j);
                           Y1=Y1-mean(Y1);
                           Y1=Y1/max(abs(Y1));    % нормировка
                          frs1 = melcepst(Y1,Fs,'dD',12,p,DN,NF);   % input
                       else
                           frs1 = [];
                       end
                       if en-e>DN
                           Y2=Y(e:en,j);
                           Y2=Y2-mean(Y2);
                           Y2=Y2/max(abs(Y2));    % нормировка
                           frs2 = melcepst(Y2,Fs,'dD',12,p,DN,NF);   % input
                       else
                           frs2 = [];
                       end
                      FrsCell=vertcat(frs1,frs2);
                      s1=ones(size(frs1,1),1);
                      s2=zeros(size(frs2,1),1);
                      if Blocks(i,3)==1
                         s_ID= vertcat(s1,s2);
                      else
                         s_ID= vertcat(s2,s1);
                      end
%                       size(FrsCell)
%                      size(s_ID)
                  end
                  
                  C = vertcat(C,FrsCell);
                  ID_in = vertcat(ID_in,s_ID);
              end  
             end
           end
           end  
            
            
            
    end
           

       
    end
       succes=succes+1;
  end
end 
szC=size(C);
szID=size(ID_in);
%% Тренировка Сети
        MainPath = 'C:\Users\User\Desktop\';
        TrainFileX = strcat(MainPath,'audio-inputALL.mat' );
        save(TrainFileX, 'C');
        TrainFileT = strcat(MainPath,'audio-targetALL.mat' );
        save(TrainFileT, 'ID_in');
x=C;
t=ID_in;

 net = patternnet(hiddenLayerSize, trainFcn);

        % Setup Division of Data for Training, Validation, Testing
        net.divideParam.trainRatio = 80/100;
        net.divideParam.valRatio = 20/100;
        net.divideParam.testRatio = 0/100;


        tic
        % Train the Network

        net = train(net,x,t,'useParallel','yes');
        
   netfile=strcat(MainPath,'netALL.mat' );   
   save(netfile,'net')

        
      