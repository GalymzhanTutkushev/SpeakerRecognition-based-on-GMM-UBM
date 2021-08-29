function y=SeparateWav(Y0,Fs)
%Возвращает список блоков, несодержащих низкоэнергичные участки
%Y0 - сигнал
%Fs - частота дискретизации
  y=zeros(1,2); %список блоков
  FrameSizeMS = 0.01;%Длина окна анализа в сек
  FrameSizeSampl = Fs*FrameSizeMS;%Длина окна в сэмплах
  LenWav = length(Y0);
  FrameCount=fix(LenWav/FrameSizeSampl)-1;%Кол-во окон
  Std=std(Y0);
  Porog =2*Std; % пороговое значение
  J = 0;
  Si = 0;
  II=0;
  Beg=0;
  End=0;
  y(1,1)=1;
  y(1,2)=length(Y0);
  for I=1:FrameCount
      %Начало окна
      N1 = (I-1)*FrameSizeSampl + 1;
      %Конец окна
      N2 = N1 + FrameSizeSampl;
      Y=Y0(N1:N2);     
      %Размах значений в текущем окне
      R=max(Y)-min(Y);
      if R>Porog
          J=J+1;
          if J==1
              Beg = N1+round(FrameSizeSampl/2);%начало - середина окна
          end
          Si = 0;
      else
          Si = Si + 1;
          if J>5 && Si<4 %если кол-во подряд идущих окон>3
              End = N1+round(FrameSizeSampl/2);%конец - середина окна
              II=II+1;
              y(II,1)=Beg;
              y(II,2)=End;
          end
          J=0;
      end
  end
  %для включения последнего окна
  if Beg>0 && End==0
      End = N1+round(FrameSizeSampl/2);
      II=II+1;
      y(II,1)=Beg;
      y(II,2)=End;
  end