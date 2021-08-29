function [reY,blocks]=betterVAD(Y,Fs)
blocks=[];
tframe=0.01;                        % длительность фрейма 10 мс
Nsamples=Fs*tframe;                % количество точек в фрейме
tfull=floor(length(Y)/Fs);          % длительность аудио                              % частота дискретизации 
Nframes=fix(tfull/tframe);       % количество фреймов 
%%%%%%%%%%%%%%%%%%%   расчет энергии каждого фрейма   %%%%%%%%%%%%%%%%%%%%%%
Eframe=zeros(1,Nframes);
YY = cell(Nframes,3);
for i=1:Nframes                
    lower=(i-1)*Nsamples+1;             % нижн€€ граница фрейма
    upper=i*Nsamples;           % верхн€€ граница фрейма
    YY{i,1} = Y(lower:upper);
    YY{i,2} = lower;
    YY{i,3} = upper;
end

parfor i=1:Nframes                
    Eframe(i)=sum((YY{i,1}).^2);     % расчет энергии отдельного фрейма
end

[fff,Epor]=hist(Eframe,200);

p=1;     % номер столбца гистограммы
o=fff(p);     % количество фреймов в столбцax
%%%%%%%%% определени€ порога отбора %%%%%%%%%%%%%%%%
per=fff(p)/Nframes;
while(per<0.6)   %  вырезаем 60 процентов 
    p=p+1;    % переходим к следующему фрейму
  o=fff(p)+o;
  per=o/Nframes;
end
Ep=Epor(p);

k=1;

 %%%%%%%%%%%%%%%%%  выбор необходимых фреймов (только голос) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 iter=zeros(1,Nframes);
 for i=1:Nframes   
     if(Eframe(i)>Ep)   % условие отбора фрейма 
        %  Ere(k)=Eframe(i);    % энерги€ отобранных фреймов
         iter(k)=i;           % номер отобранных фреймов
         k=k+1;
     end
 end
%  Ere=Ere(1,1:k);
 iter=iter(1,1:k-1);
%  Nre=length(Ere);    % количество отобранных фреймов         
%  RE=Nre/Nframes*100; % процент отобранных фреймов
 Hf=zeros(length(iter),1);

%%%%%%%%%%%%%%% запись выбранных фреймов в массив и сохранение в аудиофайл%%
if(~isempty(iter) && length(iter)>2000)
    YYY=cell(length(iter),3);
    for i = 1:length(iter)
        YYY{i,1}=YY{iter(i),1};
        YYY{i,2}=YY{iter(i),2};
        YYY{i,3}=YY{iter(i),3};
    end
parfor i=1:length(iter)
    E=abs(fft(YYY{i,1},1024));
    E=E(1:512);
    sumE=zeros(1,8);
    for d=0:512/64-1
        start=d*64+1;
        sumE(d+1)=sum(E(start:start+63)); 
    end
    E=nonzeros(E);
    p=sumE/sum(E);
    entr=-sum(p.*log2(p));                    % расчет энтропии отдельного фрейма
    Hf(i)=entr;                             % запись энтропии отдельного фрейма в массив  
end
p(1:8)=1/8;
maxHf=-sum(p.*log2(p)); 
Hf=Hf/maxHf;
%%%%%%%%%%%%%%%%%%%   расчет энергии каждого фрейма   %%%%%%%%%%%%%%%%%%%%%%

u=1;
iter=zeros(length(Hf),1);

for i=1:length(iter)
    if Hf(i)<max(Hf)*0.84   % условие отбора фрейма
        iter(u)=i;           % номер отобранных фреймов
        u=u+1;
    end
end
iter=nonzeros(iter);

  blocks(1,1)=1;
     blocks(1,2)=Nsamples;
FramesInBlock=0; ii=0;

for s=1:length(iter)-1
   
    if(iter(s+1)==iter(s)+1)
        FramesInBlock=FramesInBlock+1;
        
    else
        silence=iter(s+1)-iter(s);
      if(FramesInBlock>20 && silence>10)
        ii=ii+1;
        Begin=(iter(s)-FramesInBlock)*Nsamples;
        End=Nsamples*iter(s);
    blocks(ii,1)=Begin;
     blocks(ii,2)=End;
 
      end
      if silence>10
       FramesInBlock=0;
      end
    end
   
end

  
else
    reY=0;
  blocks=0;
   
%    fff=1/8/0.02;
end

   
end
 