function [C_in,ID_in]=NN_train_VAD_RNN(beg,en,PathSpeech,FileListS)
%% 
C = [];ID_in=[];
n=0;
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
             if isnan(b) && isnan(e)  
                if i==1 
                     b=1;
                     e=Blocks(i+1,1);
                    
                else
                     b=Blocks(i-1,2);
                     e=Blocks(i+1,1);  
                end
             end

             if e-b>160

                    Y0 = Y(b:e,j);
                    Y0 = Y0-mean(Y0);
                    Y0 = filter(1,preemph,Y0);
                    Y0 = Y0/max(abs(Y0));    % нормировка
                    FrsCell = melcepst(Y0,Fs,'',12,p,DN,NF);   % input
                    s_ID=Blocks(i,3);
                    
             else
                 FrsCell = [];
                 s_ID = [];
             end
             if ~isempty(FrsCell)
                n=n+1; 
                C{n} =  FrsCell';
                ID_in(n) = s_ID;
             end
           end
         end  
    end
  end
end 
% C_in=C;
C_in=C';
ID_in=categorical(ID_in');
% szC=size(C_in);
% szID=size(ID_in);
%         MainPath = 'C:\Users\Галым\Desktop\train_NN_VAD\';
%         RESFile = strcat(MainPath,'audio-inputA.mat' );
%         save(RESFile, 'C_in');
%         RESFile = strcat(MainPath,'audio-targetA.mat' );
%         save(RESFile, 'ID_in');