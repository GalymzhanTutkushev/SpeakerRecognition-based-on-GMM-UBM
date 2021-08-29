function [C_in,ID_in]=NN_train_VADst(beg,en,PathSpeech,FileListS)
%% 
C = [];ID_in=[];

succes=0;
for I=beg:en
    WavFileS = strcat(PathSpeech,FileListS(I).name);
 
  if WavFileS(end-3:end)=='.wav'
    disp(WavFileS)
    [Y,Fs] = audioread(WavFileS);
    XlsData = strcat(PathSpeech,'exl\',FileListS(I).name(1:end-4),'.xlsx');
 disp(XlsData)
 
    Chan=size(Y,2);
    p = floor(3*log(Fs));    %количество треугольных окон
    preemph = [1 0.97];      %коэфициенты фильтрв
    DN=0.02*Fs;              %длина кадра
    NF=0.01*Fs;              %шаг сдвига кадра
    
    for j=1:Chan
         
     Blocks = xlsread(XlsData,j);
     N=size(Blocks,1);
    
         for i=1:N
           if  ~isnan(Blocks(i,3))
        
                b=Blocks(i,1);
                e=Blocks(i,2);
                     if b==0
                         b=1;
                     end
%              if isnan(b) && isnan(e)  
%                 if i==1 
%                      b=1;
%                      e=Blocks(i+1,1);
%                     
%                 else
%                      b=Blocks(i-1,2);
%                      e=Blocks(i+1,1);  
%                 end
%              end
%         disp(b)      
%              disp(e)
%         disp(size(Y))
%           disp(j)
             if e-b>160

                    Y0 = Y(b:e,j);
                    Y0 = Y0-mean(Y0);
                    Y0 = filter(1,preemph,Y0);
                    Y0 = Y0/max(abs(Y0));    % нормировка
                    
                    FrsCell = melcepst(Y0,Fs,'dD',12,p,DN,NF);   % input
                  
                     if(Blocks(i,3)==1)
                        s_ID=ones(size(FrsCell,1),1);
                     else
                        s_ID=zeros(size(FrsCell,1),1);
                     end
                    
                     
             else
                 FrsCell = [];
                 s_ID = [];
             end
                
                  C = vertcat(C,FrsCell);
                  ID_in = vertcat(ID_in,s_ID);
          
           end
          end   
    end
       succes=succes+1;
  end
end 

C_in=C;
