clear;clc;
load('matlabNET2019')
    PathSpeech='D:\Galym stuff\matal\audio2019\analiz\';
    FileList = GetFileList(PathSpeech,2);
    Nt = length(FileList);
    eN=0;eG=0;nb=0;k=0;
%     xx=100:500:5000;
for I=1:1
%     WavFileS = strcat(PathSpeech,FileList(I).name);
 WavFileS =strcat(PathSpeech,'5A408D1D3136B9E9.wav');
  if WavFileS(end-3:end)=='.wav'
%     disp(WavFileS)
    [Y,Fs] = audioread(WavFileS);
    XlsData = strcat(PathSpeech,'exl\',FileList(I).name(1:end-4),'A.xlsx');
%     disp(XlsData)
    Chan=size(Y,2);
    p = floor(3*log(Fs));    %количество треугольных окон
    preemph = [1 0.97];      %коэфициенты фильтрв
    DN=0.02*Fs;              %длина кадра
    NF=0.01*Fs;              %шаг сдвига кадра
    
    for j=1:Chan
         
     Blocks = xlsread(XlsData,j);
     N=size(Blocks,1);
     nb=nb+N;
         for i=1:N
             
           if  ~isnan(Blocks(i,3))
        
                b=Blocks(i,1);
                e=Blocks(i,2);
           if b==0
                b=1;
           end
           if(Blocks(i,3)==1)
%                if e-b<4000
                 k=k+1;
                 statF(k)=e-b;
%                end
           end
          jstr = strcat('канал: ',num2str(j));
          istr = strcat('строка: ',num2str(i));
           if e-b<400 && Blocks(i,3)==1
              disp('Слишком короткая фонема');
%               disp(XlsData);
              disp(jstr);
              disp(istr);
                eG=eG+1;
           end
           if e-b>4000 && Blocks(i,3)==1
              disp('Слишком длинная фонема');
%               disp(XlsData);
              disp(jstr);
              disp(istr);
                eG=eG+1;
           end
           if e-b==0
                 eG=eG+1;
              disp('Начало и конец совпадают'); 
%               disp(XlsData);
              disp(jstr);
              disp(istr);
           end
           if e-b>160
               Y0 = Y(b:e,j);
               yy=Y0;
               Y0 = Y0-mean(Y0);
               Y0 = filter(1,preemph,Y0);
               Y0 = Y0/max(abs(Y0));    % нормировка
               FrsCell = melcepst(Y0,Fs,'',12,p,DN,NF);   % input
                  
                     if(Blocks(i,3)==1)
                        s_ID=ones(size(FrsCell,1),1);
                     else
                        s_ID=zeros(size(FrsCell,1),1);
                     end
                     
         y = net(FrsCell');
         performance = perform(net,s_ID',y);
         [c,cm] = confusion(s_ID',y);
         sumcm=sum(sum(cm));
         err=(cm(1,2)+cm(2,1))/sumcm*100;
%          disp(err)
         err1=cm(1,2)/sumcm*100;
         errstr =strcat('Ошибка данного фрагмента составляет:',num2str(err), '%');
         errAll(i)=err;
         if (err1~=0)
            errAll1(i)=err1;
         end
         if(err>50)
             
             eN=eN+1;
             disp(errstr);
%              disp(cm)
%               disp(XlsData);
              disp(jstr);
              disp(istr);
%                      if(Blocks(i,3)==1)
%                       audiowrite(strcat(PathSpeech,'A','one',num2str(j),num2str(i),'.wav'),yy,Fs)
%                      else
%                       audiowrite(strcat(PathSpeech,'A','zero',num2str(j),num2str(i),'.wav'),yy,Fs)
%                      end
         end
           else
               FrsCell = [];
               s_ID = [];
           end
           end
         end 
         figure(j)
          hist(statF,100);
%           hist(errAll,10)
%           hist(errAll1,10)
    end
  end
end 